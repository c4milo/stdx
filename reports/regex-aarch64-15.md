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
| literal: a word | 217 | 19020.49 ± 1.9% | 10773.63 ± 1.0% | 28.13 ± 0.5% | 17787.96 ± 3.5% | 9016.49 ± 10.5% | 17.43 ± 0.4% | 86.75 ± 0.2% | 19070.32 ± 2.6% | 1.77 | 1.00 | 1.07 | 2.11 |
| literal: a word that is not there | 0 | 21107.61 ± 2.4% | 9789.99 ± 0.9% | 28.33 ± 0.4% | 19035.99 ± 1.9% | 28047.80 ± 3.5% | 17.23 ± 0.3% | 80.90 ± 0.1% | 20893.53 ± 2.4% | 2.16 | 1.01 | 1.11 | 0.75 |
| literal: one of four words | 661 | 6413.28 ± 0.5% | 1787.40 ± 0.4% | 14.40 ± 0.1% | 3941.90 ± 0.2% | 21.88 ± 0.2% | 5.27 ± 0.2% | 6.94 ± 0.2% | 6425.76 ± 0.7% | 3.59 | 1.00 | 1.63 | 293.10 |
| literal: a word in any case | 217 | 15046.66 ± 1.2% | 1916.13 ± 0.3% | 21.60 ± 0.3% | 3965.89 ± 0.1% | 37.98 ± 0.6% | refused | differs | 15011.21 ± 1.2% | 7.85 | 1.00 | 3.79 | 396.22 |
| literal: an href attribute | 33 | 16634.44 ± 3.2% | 609.06 ± 0.3% | 27.24 ± 0.2% | 16752.67 ± 2.2% | 2254.88 ± 0.2% | 13.30 ± 0.1% | 75.68 ± 0.3% | 16804.25 ± 1.4% | 27.31 | 0.99 | 0.99 | 7.38 |
| literal: a word, second text | 123 | 19304.01 ± 3.5% | 4574.35 ± 0.3% | 27.95 ± 0.4% | 17905.97 ± 2.4% | 7653.89 ± 4.3% | 19.78 ± 0.8% | 71.21 ± 0.4% | 19343.97 ± 1.8% | 4.22 | 1.00 | 1.08 | 2.52 |
| class: two capitalized words | 1331 | 1178.44 ± 0.5% | 599.27 ± 0.2% | 25.96 ± 0.1% | 586.29 ± 0.0% | 40.69 ± 4.3% | 14.84 ± 0.2% | 68.06 ± 0.2% | 1178.15 ± 0.4% | 1.97 | 1.00 | 2.01 | 28.96 |
| class: a word that ends in ing | 3399 | 575.01 ± 0.3% | 574.25 ± 0.3% | 17.89 ± 0.2% | 548.11 ± 0.1% | 29.60 ± 1.5% | 8.13 ± 0.1% | 18.39 ± 0.2% | 575.95 ± 0.4% | 1.00 | 1.00 | 1.05 | 19.42 |
| class: a word in capitals | 2332 | 1534.56 ± 0.3% | 608.05 ± 0.2% | 27.56 ± 0.2% | 572.79 ± 0.1% | 43.46 ± 0.3% | 17.21 ± 0.4% | 83.36 ± 0.2% | 1534.22 ± 0.2% | 2.52 | 1.00 | 2.68 | 35.31 |
| class: a number | 8288 | 2666.41 ± 0.8% | 841.10 ± 0.1% | 27.70 ± 0.2% | 1719.63 ± 0.2% | 38.57 ± 15.6% | 0.56 ± 0.2% | 57.22 ± 0.2% | 2664.33 ± 0.4% | 3.17 | 1.00 | 1.55 | 69.13 |
| class: two capitalized words, second text | 5359 | 521.43 ± 0.2% | 528.22 ± 0.1% | 23.24 ± 0.2% | 482.76 ± 0.2% | 33.80 ± 10.1% | 16.75 ± 0.2% | 63.31 ± 1.4% | 521.62 ± 0.3% | 0.99 | 1.00 | 1.08 | 15.43 |
| other: a word between two words | 6104 | 811.30 ± 0.0% | 602.51 ± 0.1% | 23.44 ± 0.2% | 739.62 ± 0.3% | 109.24 ± 13.6% | 11.26 ± 0.3% | 69.54 ± 0.8% | 810.64 ± 0.3% | 1.35 | 1.00 | 1.10 | 7.43 |
| other: a number before a unit, second text | 1481 | 6236.95 ± 1.3% | 1142.03 ± 0.4% | 25.97 ± 0.2% | 5594.31 ± 0.8% | 40.90 ± 1.4% | 17.72 ± 0.2% | 65.85 ± 0.2% | 6220.53 ± 1.2% | 5.46 | 1.00 | 1.11 | 152.51 |
| other: a heading's start tag | 110 | 14143.33 ± 1.9% | 739.65 ± 0.2% | 27.33 ± 0.3% | 1706.77 ± 0.1% | 1581.52 ± 6.3% | 16.35 ± 0.3% | 87.80 ± 0.5% | 14159.11 ± 0.8% | 19.12 | 1.00 | 8.29 | 8.94 |
| other: a whole word | 217 | 16006.86 ± 0.2% | 600.70 ± 0.5% | 28.74 ± 0.4% | 14285.11 ± 0.6% | 49.30 ± 0.3% | 13.53 ± 0.1% | 55.39 ± 1.0% | 16106.95 ± 1.0% | 26.65 | 0.99 | 1.12 | 324.68 |
| other: a line's first word, second text | 3716 | 2098.42 ± 0.4% | 592.88 ± 0.6% | 30.84 ± 0.2% | 1724.89 ± 0.3% | 62.13 ± 6.9% | refused | refused | 2103.01 ± 0.5% | 3.54 | 1.00 | 1.22 | 33.78 |
| other: fourteen octets before an x | 87 | 23441.94 ± 3.5% | 226.00 ± 0.3% | 6.46 ± 0.1% | 3897.81 ± 1.6% | 10.64 ± 0.3% | differs | 17.92 ± 0.1% | 23359.66 ± 7.4% | 103.72 | 1.00 | 6.01 | 2203.83 |
| other: a Greek word | 21815 | 527.97 ± 0.5% | 423.57 ± 0.3% | 30.42 ± 0.2% | 291.07 ± 0.6% | 48.05 ± 13.1% | differs | refused | 528.41 ± 0.7% | 1.25 | 1.00 | 1.81 | 10.99 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.70 ± 0.3% | 29.64 ± 0.1% | 0.86 ± 0.3% | 19.68 ± 0.4% | 2.74 ± 0.7% | differs | 4.05 ± 0.1% | 29.61 ± 0.2% | 1.00 | 1.00 | 1.51 | 10.84 |
| a UUID | 32895 | 24.67 ± 0.3% | 24.77 ± 0.1% | 0.64 ± 0.2% | 15.16 ± 0.8% | 3.12 ± 0.7% | 0.72 ± 0.2% | 3.61 ± 0.5% | 24.76 ± 0.1% | 1.00 | 1.00 | 1.63 | 7.90 |
| an IPv4 address | 33176 | 38.79 ± 0.3% | 38.83 ± 0.2% | 2.08 ± 0.3% | 29.13 ± 0.6% | 6.64 ± 0.3% | differs | 4.21 ± 0.1% | 38.74 ± 0.4% | 1.00 | 1.00 | 1.33 | 5.84 |
| a date and time | 32954 | 34.00 ± 0.1% | 34.18 ± 0.2% | 1.44 ± 0.5% | 21.48 ± 0.2% | 7.05 ± 0.1% | 1.19 ± 0.2% | 7.10 ± 0.1% | 34.15 ± 0.2% | 0.99 | 1.00 | 1.58 | 4.82 |
| a field path | 32606 | 32.84 ± 0.1% | 32.87 ± 0.4% | 1.02 ± 0.2% | 23.17 ± 0.1% | 3.50 ± 0.8% | differs | 2.96 ± 0.1% | 32.86 ± 0.3% | 1.00 | 1.00 | 1.42 | 9.39 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.24 ± 0.3% | 11.20 ± 0.5% | 11.20 ± 0.3% | 11.47 ± 0.5% | 4.93 ± 1.4% | 0.90 ± 0.6% | none | 11.21 ± 0.5% | 1.00 | 1.00 | 0.98 | 2.28 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 229.12 ± 0.3% | 228.99 ± 0.1% | 270.16 ± 0.4% | 87.22 ± 0.9% | 219.35 ± 2.3% | 489.84 ± 2.5% | 3731.89 ± 2.6% | 229.10 ± 0.1% | 1.00 | 1.00 | 2.63 | 1.04 |
| a UUID | 62 | 151.91 ± 0.0% | 152.10 ± 0.1% | 169.62 ± 0.3% | 46.70 ± 1.0% | 98.78 ± 0.4% | 193.08 ± 2.4% | 4362.89 ± 0.8% | 151.99 ± 0.1% | 1.00 | 1.00 | 3.25 | 1.54 |
| an IPv4 address | 29 | 422.13 ± 0.3% | 422.32 ± 0.2% | 588.13 ± 0.3% | 78.33 ± 0.2% | 129.95 ± 0.7% | 303.12 ± 0.5% | 7553.31 ± 0.3% | 422.54 ± 0.2% | 1.00 | 1.00 | 5.39 | 3.25 |
| a date and time | 56 | 302.09 ± 0.4% | 302.33 ± 0.5% | 378.42 ± 0.4% | 71.15 ± 0.3% | 136.53 ± 1.5% | 326.13 ± 0.5% | 4941.50 ± 0.4% | 301.97 ± 0.5% | 1.00 | 1.00 | 4.25 | 2.21 |
| a field path | 39 | 224.50 ± 0.2% | 224.62 ± 0.2% | 263.92 ± 0.1% | 80.42 ± 0.1% | 205.20 ± 0.7% | 503.72 ± 1.8% | 4752.12 ± 0.1% | 224.46 ± 0.3% | 1.00 | 1.00 | 2.79 | 1.09 |
| literal: a word | 7 | 602.97 ± 0.6% | 649.58 ± 0.5% | 1125.51 ± 0.2% | 506.35 ± 1.1% | 623.94 ± 8.5% | 975.74 ± 1.1% | 30223.58 ± 0.6% | 604.68 ± 0.1% | 0.93 | 1.00 | 1.19 | 0.97 |
| literal: a word that is not there | 8 | 587.46 ± 0.8% | 635.86 ± 0.5% | 1090.71 ± 0.7% | 462.72 ± 0.1% | 598.28 ± 1.8% | 927.35 ± 0.3% | 29145.21 ± 0.4% | 587.36 ± 0.2% | 0.92 | 1.00 | 1.27 | 0.98 |
| literal: one of four words | 26 | 244.61 ± 0.3% | 386.86 ± 0.4% | 524.83 ± 0.4% | 50.49 ± 0.4% | 239.10 ± 1.6% | 377.50 ± 0.5% | 15598.28 ± 0.6% | 244.45 ± 0.2% | 0.63 | 1.00 | 4.84 | 1.02 |
| literal: a word in any case | 11 | 438.69 ± 0.2% | 467.78 ± 0.7% | 682.80 ± 0.4% | 15.80 ± 0.2% | 643.92 ± 1.8% | refused | 23784.20 ± 0.3% | 438.46 ± 0.5% | 0.94 | 1.00 | 27.77 | 0.68 |
| literal: an href attribute | 12 | 339.17 ± 0.3% | 351.73 ± 0.4% | 459.69 ± 0.3% | 44.96 ± 0.3% | 496.54 ± 1.6% | 779.95 ± 0.4% | 21636.62 ± 0.3% | 339.91 ± 0.2% | 0.96 | 1.00 | 7.54 | 0.68 |
| literal: a word, second text | 10 | 540.79 ± 0.6% | 592.72 ± 0.3% | 974.15 ± 0.2% | 408.34 ± 0.5% | 531.82 ± 2.0% | 806.41 ± 0.6% | 27077.03 ± 0.4% | 540.58 ± 0.7% | 0.91 | 1.00 | 1.32 | 1.02 |
| class: two capitalized words | 23 | 432.15 ± 0.2% | 459.93 ± 0.7% | 659.81 ± 0.9% | 100.50 ± 0.3% | 497.60 ± 1.2% | 750.09 ± 0.4% | 6298.63 ± 0.4% | 432.72 ± 0.5% | 0.94 | 1.00 | 4.30 | 0.87 |
| class: a word that ends in ing | 9 | 552.59 ± 0.4% | 619.20 ± 0.5% | 1069.37 ± 0.3% | 132.86 ± 0.5% | 750.16 ± 1.0% | 1109.55 ± 0.5% | 15717.74 ± 0.2% | 553.75 ± 0.5% | 0.89 | 1.00 | 4.16 | 0.74 |
| class: a word in capitals | 16 | 493.28 ± 0.3% | 528.46 ± 0.3% | 836.22 ± 0.2% | 136.68 ± 1.5% | 747.52 ± 0.2% | 1022.04 ± 1.5% | 8292.79 ± 0.1% | 492.98 ± 0.2% | 0.93 | 1.00 | 3.61 | 0.66 |
| class: a number | 6 | 621.66 ± 0.3% | 679.79 ± 0.5% | 1247.96 ± 0.1% | 42.18 ± 0.8% | 1391.82 ± 6.0% | 1899.40 ± 1.2% | 22762.47 ± 0.0% | 621.26 ± 0.3% | 0.91 | 1.00 | 14.74 | 0.45 |
| class: two capitalized words, second text | 23 | 431.86 ± 1.1% | 458.93 ± 0.3% | 659.16 ± 0.4% | 100.23 ± 1.1% | 499.35 ± 1.1% | 740.93 ± 0.3% | 6299.23 ± 0.2% | 431.95 ± 0.5% | 0.94 | 1.00 | 4.31 | 0.86 |
| other: a word between two words | 13 | 529.44 ± 0.1% | 550.34 ± 0.7% | 868.65 ± 0.2% | 132.10 ± 0.1% | 500.70 ± 2.0% | 809.28 ± 0.5% | 14570.68 ± 0.8% | 530.02 ± 0.3% | 0.96 | 1.00 | 4.01 | 1.06 |
| other: a number before a unit, second text | 15 | 391.80 ± 0.2% | 429.56 ± 0.4% | 600.49 ± 0.1% | 39.52 ± 0.4% | 630.09 ± 0.7% | 892.46 ± 0.1% | 15115.91 ± 0.2% | 391.69 ± 0.2% | 0.91 | 1.00 | 9.91 | 0.62 |
| other: a heading's start tag | 13 | 350.45 ± 0.3% | 357.43 ± 0.2% | 468.91 ± 0.4% | 43.77 ± 0.4% | 626.45 ± 0.9% | 869.27 ± 0.1% | 17975.64 ± 0.3% | 351.22 ± 0.2% | 0.98 | 1.00 | 8.01 | 0.56 |
| other: a whole word | 11 | 561.73 ± 0.7% | 599.27 ± 1.2% | 991.33 ± 0.7% | 119.19 ± 0.8% | 565.31 ± 0.8% | 822.78 ± 1.5% | 26981.94 ± 0.1% | 562.41 ± 0.4% | 0.94 | 1.00 | 4.71 | 0.99 |
| other: a line's first word, second text | 17 | 510.23 ± 0.8% | 544.38 ± 0.4% | 863.68 ± 0.6% | 128.29 ± 0.2% | 707.87 ± 0.7% | refused | refused | 510.29 ± 0.3% | 0.94 | 1.00 | 3.98 | 0.72 |
| other: fourteen octets before an x | 16 | 109.14 ± 0.9% | 156.62 ± 0.7% | 179.02 ± 0.8% | 14.92 ± 0.3% | 452.34 ± 4.2% | 414.29 ± 0.5% | 12733.25 ± 0.5% | 109.41 ± 0.4% | 0.70 | 1.00 | 7.32 | 0.24 |
| other: a Greek word | 8 | 448.65 ± 0.2% | 589.23 ± 0.3% | 984.81 ± 0.6% | 58.73 ± 1.0% | 1384.17 ± 0.9% | 1878.05 ± 0.5% | refused | 449.16 ± 0.2% | 0.76 | 1.00 | 7.64 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15382.78 ± 0.8% | not timed | not timed | 15919.66 ± 1.4% | 2157.45 ± 4.7% | not timed | not timed | 15361.04 ± 1.2% | | 1.00 | 0.97 | 7.13 |
| 01-literal/sherlock-casei-en | 522 | 10925.19 ± 4.1% | not timed | not timed | 3580.31 ± 0.4% | 32.43 ± 0.1% | not timed | not timed | 10915.78 ± 4.1% | | 1.00 | 3.05 | 336.87 |
| 01-literal/sherlock-ru | 724 | 17082.85 ± 0.7% | not timed | not timed | 17110.85 ± 2.3% | 1636.10 ± 13.1% | not timed | not timed | 17097.92 ± 1.1% | | 1.00 | 1.00 | 10.44 |
| 01-literal/sherlock-casei-ru | 746 | 6122.97 ± 0.2% | not timed | not timed | 3328.62 ± 0.2% | 31.74 ± 0.4% | not timed | not timed | 6136.41 ± 0.3% | | 1.00 | 1.84 | 192.92 |
| 01-literal/sherlock-zh | 30 | 19333.39 ± 0.5% | not timed | not timed | 18277.48 ± 0.5% | 2769.52 ± 15.8% | not timed | not timed | 19316.31 ± 0.6% | | 1.00 | 1.06 | 6.98 |
| 02-literal-alternate/sherlock-en | 714 | 6127.32 ± 0.2% | not timed | not timed | 3935.41 ± 0.1% | 16.63 ± 0.2% | not timed | not timed | 6128.57 ± 0.3% | | 1.00 | 1.56 | 368.48 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1969.85 ± 1.2% | not timed | not timed | 697.46 ± 0.2% | 11.04 ± 7.2% | not timed | not timed | 1969.74 ± 1.9% | | 1.00 | 2.82 | 178.40 |
| 02-literal-alternate/sherlock-ru | 899 | 5494.83 ± 0.1% | not timed | not timed | 3250.28 ± 0.1% | 22.68 ± 0.3% | not timed | not timed | 5502.42 ± 0.5% | | 1.00 | 1.69 | 242.27 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2050.15 ± 0.5% | not timed | not timed | 1230.28 ± 0.7% | 9.15 ± 0.1% | not timed | not timed | 2046.01 ± 0.4% | | 1.00 | 1.67 | 224.06 |
| 02-literal-alternate/sherlock-zh | 207 | 7312.63 ± 0.7% | not timed | not timed | 4160.35 ± 0.1% | 31.49 ± 0.1% | not timed | not timed | 7300.07 ± 0.9% | | 1.00 | 1.76 | 232.19 |
| 03-date/ascii | 111817 | 133.89 ± 0.7% | not timed | not timed | 96.48 ± 0.1% | 0.20 ± 2.5% | not timed | not timed | 133.98 ± 0.7% | | 1.00 | 1.39 | 661.77 |
| 04-ruff-noqa/real | 84 | 438.97 ± 0.2% | not timed | not timed | 459.61 ± 0.1% | 19.11 ± 1.1% | not timed | not timed | 437.53 ± 0.2% | | 1.00 | 0.96 | 22.97 |
| 04-ruff-noqa/tweaked | 44 | 846.46 ± 0.1% | not timed | not timed | 461.30 ± 0.1% | 365.39 ± 0.7% | not timed | not timed | 845.86 ± 0.1% | | 1.00 | 1.83 | 2.32 |
| 05-lexer-veryl/single | 124800 | 5.25 ± 0.3% | not timed | not timed | 5.05 ± 0.1% | 0.21 ± 4.2% | not timed | not timed | 5.29 ± 0.3% | | 0.99 | 1.04 | 25.50 |
| 06-cloud-flare-redos/original | 107 | 439.82 ± 0.3% | not timed | not timed | 213.66 ± 0.0% | 24.91 ± 0.4% | not timed | not timed | 438.94 ± 0.1% | | 1.00 | 2.06 | 17.65 |
| 06-cloud-flare-redos/simplified-short | 102 | 438.97 ± 0.1% | not timed | not timed | 229.07 ± 0.0% | 26.66 ± 0.1% | not timed | not timed | 437.57 ± 0.4% | | 1.00 | 1.92 | 16.46 |
| 06-cloud-flare-redos/simplified-long | 10000 | 628.84 ± 0.2% | not timed | not timed | 253.93 ± 0.3% | 28.73 ± 0.2% | not timed | not timed | 629.10 ± 0.3% | | 1.00 | 2.48 | 21.89 |
| 07-unicode-character-data/parse-line | 558784 | 240.69 ± 3.5% | not timed | not timed | 169.14 ± 0.1% | 42.81 ± 5.3% | not timed | not timed | 243.59 ± 2.7% | | 0.99 | 1.42 | 5.62 |
| 08-words/all-english | 56691 | 129.05 ± 0.7% | not timed | not timed | 83.36 ± 0.1% | 12.82 ± 10.0% | not timed | not timed | 129.28 ± 0.9% | | 1.00 | 1.55 | 10.06 |
| 08-words/long-english | 839 | 617.54 ± 0.4% | not timed | not timed | 597.55 ± 0.1% | 32.68 ± 0.1% | not timed | not timed | 617.82 ± 1.0% | | 1.00 | 1.03 | 18.90 |
| 09-aws-keys/full | 0 | 442.95 ± 0.3% | not timed | not timed | 462.15 ± 0.1% | 64.44 ± 0.2% | not timed | not timed | 442.91 ± 0.3% | | 1.00 | 0.96 | 6.87 |
| 09-aws-keys/quick | 0 | 873.53 ± 0.2% | not timed | not timed | 992.02 ± 0.1% | 424.08 ± 1.1% | not timed | not timed | 874.24 ± 0.3% | | 1.00 | 0.88 | 2.06 |
| 10-bounded-repeat/letters-en | 1833 | 576.97 ± 2.6% | not timed | not timed | 514.46 ± 0.2% | 19.60 ± 0.2% | not timed | not timed | 578.59 ± 3.0% | | 1.00 | 1.12 | 29.44 |
| 10-bounded-repeat/letters-ru | 3475 | 505.28 ± 1.9% | not timed | not timed | 478.32 ± 0.1% | 21.78 ± 9.5% | not timed | not timed | 507.50 ± 0.8% | | 1.00 | 1.06 | 23.19 |
| 10-bounded-repeat/context | 53 | 84.66 ± 2.0% | not timed | not timed | 65.75 ± 0.5% | 19.83 ± 0.3% | not timed | not timed | 85.14 ± 1.7% | | 0.99 | 1.29 | 4.27 |
| 10-bounded-repeat/capitals | 11 | 637.12 ± 8.3% | not timed | not timed | 618.56 ± 0.1% | 36.34 ± 0.1% | not timed | not timed | 637.52 ± 8.2% | | 1.00 | 1.03 | 17.53 |
| 11-unstructured-to-json/extract | 600 | 57.97 ± 0.9% | not timed | not timed | 78.08 ± 0.1% | 48.71 ± 0.6% | not timed | not timed | 57.83 ± 0.2% | | 1.00 | 0.74 | 1.19 |
| 12-dictionary/single | 1 | 561.00 ± 1.3% | not timed | not timed | 561.13 ± 0.0% | 0.41 ± 0.1% | not timed | not timed | 559.95 ± 1.6% | | 1.00 | 1.00 | 1374.82 |
| 14-quadratic/1x | 100 | 22.13 ± 0.5% | not timed | not timed | 10.02 ± 0.1% | 0.98 ± 4.1% | not timed | not timed | 22.14 ± 1.1% | | 1.00 | 2.21 | 22.66 |
| 14-quadratic/2x | 200 | 19.76 ± 1.2% | not timed | not timed | 5.52 ± 0.2% | 0.53 ± 0.9% | not timed | not timed | 19.84 ± 0.3% | | 1.00 | 3.58 | 37.43 |
| 14-quadratic/10x | 1000 | 12.29 ± 1.0% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 1.5% | not timed | not timed | 12.31 ± 1.1% | | 1.00 | 10.13 | 106.66 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 0.7% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 4.5% | not timed | not timed | 1.27 ± 2.1% | | 1.00 | 3.70 | 2.31 |
| 04-ruff-noqa/compile-real | 1 | 104.85 ± 0.8% | not timed | not timed | 13.72 ± 0.3% | 138.88 ± 1.3% | not timed | not timed | 104.93 ± 1.5% | | 1.00 | 7.64 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 14.16 ± 0.4% | not timed | not timed | 2.50 ± 0.5% | 6.36 ± 2.3% | not timed | not timed | 14.18 ± 0.6% | | 1.00 | 5.65 | 2.23 |
| 07-unicode-character-data/compile | 1 | 108.18 ± 1.1% | not timed | not timed | 25.95 ± 0.3% | 35.80 ± 3.0% | not timed | not timed | 109.03 ± 1.0% | | 0.99 | 4.17 | 3.02 |
| 09-aws-keys/compile-full | 1 | 52.89 ± 1.3% | not timed | not timed | 8.26 ± 0.7% | 23.19 ± 1.4% | not timed | not timed | 53.13 ± 0.5% | | 1.00 | 6.40 | 2.28 |
| 09-aws-keys/compile-quick | 1 | 187.55 ± 1.2% | not timed | not timed | 46.84 ± 0.3% | 133.23 ± 4.5% | not timed | not timed | 187.68 ± 0.2% | | 1.00 | 4.00 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 71.49 ± 1.8% | not timed | not timed | 11.12 ± 0.3% | 15.92 ± 2.6% | not timed | not timed | 71.44 ± 1.2% | | 1.00 | 6.43 | 4.49 |
| 10-bounded-repeat/compile-capitals | 1 | 86.02 ± 1.2% | not timed | not timed | 8.11 ± 0.3% | 23.87 ± 1.9% | not timed | not timed | 86.00 ± 1.4% | | 1.00 | 10.60 | 3.60 |
| 11-unstructured-to-json/compile | 1 | 172.90 ± 1.5% | not timed | not timed | 40.83 ± 0.7% | 68.02 ± 1.7% | not timed | not timed | 173.08 ± 0.8% | | 1.00 | 4.23 | 2.54 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.9% | not timed | not timed | 0.07 ± 37.4% | 0.09 ± 17.8% | not timed | not timed | 0.35 ± 1.6% | | 0.99 | 5.08 | 3.73 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.31 ± 5.4% | not timed | not timed | 6.50 ± 0.2% | 0.59 ± 16.7% | not timed | not timed | 7.45 ± 2.6% | | 0.98 | 1.12 | 12.45 |
| dictionary/search/english-10 | 690 | 204.50 ± 3.0% | not timed | not timed | 165.61 ± 0.7% | 0.00 ± 0.6% | not timed | not timed | 206.79 ± 3.9% | | 0.99 | 1.23 | 78476.43 |
| dictionary/search/english-15 | 15 | 561.57 ± 1.3% | not timed | not timed | 559.62 ± 0.1% | 0.37 ± 0.2% | not timed | not timed | 560.34 ± 1.7% | | 1.00 | 1.00 | 1528.46 |
| folly/awyer-inn-busted | 1 | 21498.51 ± 0.1% | not timed | not timed | 143.72 ± 0.3% | 43.86 ± 0.1% | not timed | not timed | 21554.11 ± 0.3% | | 1.00 | 149.59 | 490.11 |
| folly/literal-never-match-rare | 0 | 21054.94 ± 0.4% | not timed | not timed | 19807.09 ± 0.4% | 40719.93 ± 0.9% | not timed | not timed | 21078.40 ± 0.4% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12547.21 ± 0.7% | not timed | not timed | 19813.40 ± 0.7% | 2188.13 ± 1.0% | not timed | not timed | 12545.32 ± 0.7% | | 1.00 | 0.63 | 5.73 |
| folly/literal-never-match-tricksy | 1 | 3263.70 ± 0.4% | not timed | not timed | 4406.09 ± 0.1% | 3055.17 ± 0.1% | not timed | not timed | 3254.95 ± 0.5% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1298.79 ± 0.6% | not timed | not timed | 957.28 ± 0.1% | 386.88 ± 19.3% | not timed | not timed | 1303.24 ± 0.5% | | 1.00 | 1.36 | 3.36 |
| grep/long-words-ascii | 5073 | 459.02 ± 0.1% | not timed | not timed | 470.11 ± 0.1% | 46.02 ± 8.0% | not timed | not timed | 458.92 ± 0.3% | | 1.00 | 0.98 | 9.97 |
| imported/leipzig/twain | 811 | 20622.45 ± 1.2% | not timed | not timed | 19508.37 ± 0.6% | 11784.45 ± 9.8% | not timed | not timed | 20657.11 ± 0.8% | | 1.00 | 1.06 | 1.75 |
| imported/leipzig/twain-insensitive | 965 | 9022.54 ± 2.0% | not timed | not timed | 4245.67 ± 0.1% | 37.63 ± 0.1% | not timed | not timed | 9087.75 ± 1.5% | | 0.99 | 2.13 | 239.78 |
| imported/leipzig/shing | 1540 | 15250.96 ± 2.3% | not timed | not timed | 13411.29 ± 1.2% | 33.84 ± 0.1% | not timed | not timed | 15444.39 ± 2.5% | | 0.99 | 1.14 | 450.74 |
| imported/leipzig/huck-saw | 262 | 8269.74 ± 2.5% | not timed | not timed | 5588.89 ± 0.2% | 31.42 ± 0.2% | not timed | not timed | 8411.60 ± 2.9% | | 0.98 | 1.48 | 263.22 |
| imported/leipzig/word-ending-nn | 262 | 602.62 ± 0.8% | not timed | not timed | 615.70 ± 0.0% | 24.45 ± 0.4% | not timed | not timed | 601.85 ± 0.7% | | 1.00 | 0.98 | 24.65 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11151.14 ± 41.6% | not timed | not timed | 4466.93 ± 26.6% | 11.36 ± 0.1% | not timed | not timed | 11180.46 ± 46.5% | | 1.00 | 2.50 | 981.96 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7807.62 ± 1.9% | not timed | not timed | 5483.60 ± 0.2% | 16.73 ± 0.1% | not timed | not timed | 7903.05 ± 2.0% | | 0.99 | 1.42 | 466.65 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4174.29 ± 0.8% | not timed | not timed | 414.96 ± 0.4% | 10.95 ± 0.1% | not timed | not timed | 4180.62 ± 0.8% | | 1.00 | 10.06 | 381.10 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7273.75 ± 3.7% | not timed | not timed | 614.85 ± 0.1% | 10.89 ± 0.1% | not timed | not timed | 7376.16 ± 2.5% | | 0.99 | 11.83 | 667.75 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7176.59 ± 2.3% | not timed | not timed | 615.26 ± 0.1% | 9.60 ± 0.0% | not timed | not timed | 7285.91 ± 2.0% | | 0.98 | 11.66 | 747.77 |
| imported/leipzig/tom-river | 2 | 6461.21 ± 6.8% | not timed | not timed | 5142.50 ± 3.4% | 30.70 ± 0.3% | not timed | not timed | 6585.69 ± 1.8% | | 0.98 | 1.26 | 210.46 |
| imported/leipzig/ing | 78424 | 603.89 ± 0.8% | not timed | not timed | 572.44 ± 0.0% | 28.01 ± 3.2% | not timed | not timed | 601.95 ± 1.0% | | 1.00 | 1.05 | 21.56 |
| imported/leipzig/ing-whitespace | 55248 | 1925.22 ± 1.2% | not timed | not timed | 2010.59 ± 0.3% | 20.42 ± 2.8% | not timed | not timed | 1938.15 ± 0.9% | | 0.99 | 0.96 | 94.26 |
| imported/leipzig/awyer-inn | 209 | 6375.51 ± 1.7% | not timed | not timed | 4281.52 ± 0.1% | 22.43 ± 0.1% | not timed | not timed | 6413.92 ± 1.0% | | 0.99 | 1.49 | 284.24 |
| imported/leipzig/quotes-bounded | 8886 | 2493.94 ± 1.2% | not timed | not timed | 3024.02 ± 0.2% | 37.89 ± 0.1% | not timed | not timed | 2507.66 ± 1.6% | | 0.99 | 0.82 | 65.81 |
| imported/leipzig/non-ascii-alternate | 2 | 12771.52 ± 8.3% | not timed | not timed | 5650.32 ± 6.4% | 50.52 ± 0.4% | not timed | not timed | 13074.35 ± 5.1% | | 0.98 | 2.26 | 252.80 |
| imported/leipzig/math-symbols | 69 | 1979.51 ± 1.0% | not timed | not timed | 614.25 ± 0.2% | 36.42 ± 0.2% | not timed | not timed | 1978.59 ± 0.8% | | 1.00 | 3.22 | 54.35 |
| imported/leipzig/bounded-strings-ending-z | 0 | 629.02 ± 1.7% | not timed | not timed | 617.95 ± 0.1% | 22.13 ± 0.0% | not timed | not timed | 630.00 ± 1.6% | | 1.00 | 1.02 | 28.43 |
| imported/lh3lh3-reb/uri | 17549 | 677.55 ± 0.2% | not timed | not timed | 1075.65 ± 0.2% | 28.18 ± 2.2% | not timed | not timed | 679.87 ± 0.2% | | 1.00 | 0.63 | 24.04 |
| imported/lh3lh3-reb/email | 15057 | 673.81 ± 0.1% | not timed | not timed | 1155.62 ± 0.3% | 30.82 ± 2.7% | not timed | not timed | 675.98 ± 0.1% | | 1.00 | 0.58 | 21.86 |
| imported/lh3lh3-reb/date | 668 | 892.00 ± 0.2% | not timed | not timed | 1032.68 ± 0.2% | 50.78 ± 3.8% | not timed | not timed | 892.83 ± 0.2% | | 1.00 | 0.86 | 17.57 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.35 ± 0.3% | not timed | not timed | 424.60 ± 0.1% | 15.71 ± 1.5% | not timed | not timed | 646.98 ± 0.1% | | 1.00 | 1.52 | 41.07 |
| imported/mariomka/email | 92 | 24078.69 ± 0.6% | not timed | not timed | 29392.07 ± 3.1% | 32.79 ± 0.1% | not timed | not timed | 24312.74 ± 1.3% | | 0.99 | 0.82 | 734.34 |
| imported/mariomka/uri | 5301 | 5537.71 ± 0.6% | not timed | not timed | 6088.60 ± 0.4% | 32.75 ± 0.4% | not timed | not timed | 5584.83 ± 1.0% | | 0.99 | 0.91 | 169.11 |
| imported/mariomka/ip | 5 | 2599.06 ± 2.6% | not timed | not timed | 2968.39 ± 0.4% | 21.05 ± 0.2% | not timed | not timed | 2599.61 ± 3.2% | | 1.00 | 0.88 | 123.49 |
| imported/rsc/no-exponential | 0 | 607.63 ± 0.1% | not timed | not timed | 320.52 ± 0.0% | 23.86 ± 0.3% | not timed | not timed | 608.10 ± 0.0% | | 1.00 | 1.90 | 25.46 |
| imported/rsc/literal | 1 | 1497.31 ± 2.3% | not timed | not timed | 1547.97 ± 7.1% | 189.36 ± 17.5% | not timed | not timed | 1492.78 ± 5.7% | | 1.00 | 0.97 | 7.91 |
| imported/rsc/not-literal | 2 | 777.51 ± 0.2% | not timed | not timed | 739.19 ± 0.6% | 46.18 ± 8.5% | not timed | not timed | 780.15 ± 2.0% | | 1.00 | 1.05 | 16.84 |
| imported/rsc/match-class | 1 | 1474.99 ± 2.2% | not timed | not timed | 1634.18 ± 0.3% | 58.42 ± 6.7% | not timed | not timed | 1478.33 ± 0.5% | | 1.00 | 0.90 | 25.25 |
| imported/rsc/match-class-in-range | 1 | 1473.24 ± 2.1% | not timed | not timed | 2388.54 ± 6.6% | 59.80 ± 6.1% | not timed | not timed | 1476.74 ± 0.6% | | 1.00 | 0.62 | 24.64 |
| imported/rsc/match-class-unicode | 1 | 540.62 ± 1.9% | not timed | not timed | 510.17 ± 0.2% | 72.15 ± 7.7% | not timed | not timed | 540.89 ± 0.3% | | 1.00 | 1.06 | 7.49 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1454.72 ± 0.1% | not timed | not timed | 954.33 ± 0.1% | 229.25 ± 0.7% | not timed | not timed | 1451.17 ± 0.2% | | 1.00 | 1.52 | 6.35 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21803.80 ± 0.2% | not timed | not timed | 14299.45 ± 0.2% | 3446.44 ± 0.4% | not timed | not timed | 21751.05 ± 0.2% | | 1.00 | 1.52 | 6.33 |
| imported/rsc/anchored-literal-short-match | 4 | 724.34 ± 1.7% | not timed | not timed | 489.82 ± 0.1% | 85.85 ± 5.1% | not timed | not timed | 723.78 ± 2.1% | | 1.00 | 1.48 | 8.44 |
| imported/rsc/anchored-literal-long-match | 4 | 10855.72 ± 8.1% | not timed | not timed | 7417.01 ± 0.2% | 1262.71 ± 9.1% | not timed | not timed | 10831.07 ± 2.0% | | 1.00 | 1.46 | 8.60 |
| imported/rsc/one-pass-short | 17 | 365.39 ± 9.6% | not timed | not timed | 216.54 ± 0.8% | 30.90 ± 12.3% | not timed | not timed | 370.55 ± 0.7% | | 0.99 | 1.69 | 11.83 |
| imported/rsc/one-pass-short-not | 17 | 270.17 ± 2.2% | not timed | not timed | 225.26 ± 0.1% | 29.82 ± 10.3% | not timed | not timed | 269.82 ± 3.7% | | 1.00 | 1.20 | 9.06 |
| imported/rsc/one-pass-long-prefix | 26 | 360.80 ± 7.7% | not timed | not timed | 284.56 ± 0.4% | 98.86 ± 10.2% | not timed | not timed | 360.17 ± 2.0% | | 1.00 | 1.27 | 3.65 |
| imported/rsc/one-pass-long-prefix-not | 26 | 358.49 ± 6.4% | not timed | not timed | 278.22 ± 0.3% | 67.96 ± 14.4% | not timed | not timed | 362.32 ± 1.9% | | 0.99 | 1.29 | 5.28 |
| imported/rsc/long-needle1 | 31 | 21928.18 ± 0.0% | not timed | not timed | 20158.37 ± 0.1% | 3.75 ± 0.1% | not timed | not timed | 21931.30 ± 0.1% | | 1.00 | 1.09 | 5841.41 |
| imported/rsc/long-needle2 | 31 | 22088.86 ± 0.1% | not timed | not timed | 216.26 ± 0.3% | 3.76 ± 0.0% | not timed | not timed | 22089.67 ± 0.2% | | 1.00 | 102.14 | 5881.03 |
| imported/rsc/easy0-32 | 26 | 1575.96 ± 0.2% | not timed | not timed | 1617.22 ± 2.5% | 148.76 ± 20.4% | not timed | not timed | 1560.61 ± 2.1% | | 1.01 | 0.97 | 10.59 |
| imported/rsc/easy0-1k | 26 | 13658.17 ± 0.2% | not timed | not timed | 12656.24 ± 1.3% | 2282.26 ± 13.9% | not timed | not timed | 13651.21 ± 2.6% | | 1.00 | 1.08 | 5.98 |
| imported/rsc/easy0-32k | 26 | 22769.31 ± 0.3% | not timed | not timed | 20359.01 ± 0.1% | 18754.26 ± 7.4% | not timed | not timed | 22775.35 ± 11.0% | | 1.00 | 1.12 | 1.21 |
| imported/rsc/easy0-1mb | 26 | 21403.96 ± 3.9% | not timed | not timed | 19753.34 ± 3.3% | 36225.02 ± 3.4% | not timed | not timed | 21443.32 ± 1.6% | | 1.00 | 1.08 | 0.59 |
| imported/rsc/easy1-32 | 19 | 770.94 ± 2.5% | not timed | not timed | 639.28 ± 0.3% | 138.06 ± 16.8% | not timed | not timed | 770.78 ± 7.8% | | 1.00 | 1.21 | 5.58 |
| imported/rsc/easy1-1k | 19 | 15772.26 ± 2.5% | not timed | not timed | 12958.42 ± 0.2% | 2462.82 ± 14.0% | not timed | not timed | 15816.06 ± 0.6% | | 1.00 | 1.22 | 6.40 |
| imported/rsc/easy1-32k | 19 | 494332.55 ± 0.1% | not timed | not timed | 411031.12 ± 0.1% | 20454.72 ± 0.1% | not timed | not timed | 495334.71 ± 0.4% | | 1.00 | 1.20 | 24.17 |
| imported/rsc/easy1-1mb | 19 | 15900990.07 ± 0.2% | not timed | not timed | 13250033.23 ± 0.4% | 37272.39 ± 4.1% | not timed | not timed | 15883348.50 ± 0.3% | | 1.00 | 1.20 | 426.62 |
| imported/rsc/medium-32 | 27 | 739.84 ± 1.7% | not timed | not timed | 639.38 ± 0.2% | 69.80 ± 10.6% | not timed | not timed | 741.06 ± 0.1% | | 1.00 | 1.16 | 10.60 |
| imported/rsc/medium-1k | 27 | 13180.54 ± 0.3% | not timed | not timed | 11541.34 ± 0.2% | 72.38 ± 0.1% | not timed | not timed | 13142.71 ± 0.2% | | 1.00 | 1.14 | 182.11 |
| imported/rsc/medium-32k | 27 | 410948.22 ± 0.1% | not timed | not timed | 351709.36 ± 0.2% | 49.07 ± 0.1% | not timed | not timed | 409943.82 ± 0.4% | | 1.00 | 1.17 | 8374.88 |
| imported/rsc/medium-1mb | 27 | 13147624.54 ± 0.2% | not timed | not timed | 11507013.15 ± 0.6% | 48.82 ± 0.1% | not timed | not timed | 13089909.67 ± 0.1% | | 1.00 | 1.14 | 269295.22 |
| imported/rsc/hard-32 | 58 | 423.47 ± 2.0% | not timed | not timed | 362.70 ± 0.1% | 49.64 ± 8.6% | not timed | not timed | 421.59 ± 0.3% | | 1.00 | 1.17 | 8.53 |
| imported/rsc/hard-1k | 27 | 12890.40 ± 0.2% | not timed | not timed | 11706.23 ± 0.3% | 40.75 ± 0.1% | not timed | not timed | 12822.88 ± 0.2% | | 1.01 | 1.10 | 316.31 |
| imported/rsc/hard-32k | 27 | 402701.21 ± 0.2% | not timed | not timed | 363794.85 ± 0.3% | 29.38 ± 0.1% | not timed | not timed | 400530.99 ± 0.3% | | 1.01 | 1.11 | 13707.50 |
| imported/rsc/hard-1mb | 51 | 8377881.88 ± 0.1% | not timed | not timed | 7247344.85 ± 0.4% | 29.47 ± 0.1% | not timed | not timed | 8359539.06 ± 0.1% | | 1.00 | 1.16 | 284300.15 |
| imported/rsc/reallyhard0-32 | 58 | 262.81 ± 2.3% | not timed | not timed | 224.11 ± 0.1% | 49.60 ± 8.2% | not timed | not timed | 262.13 ± 0.1% | | 1.00 | 1.17 | 5.30 |
| imported/rsc/reallyhard0-1k | 27 | 582.52 ± 0.6% | not timed | not timed | 585.68 ± 0.2% | 40.55 ± 0.1% | not timed | not timed | 582.26 ± 0.2% | | 1.00 | 0.99 | 14.37 |
| imported/rsc/reallyhard0-32k | 27 | 601.72 ± 0.2% | not timed | not timed | 613.61 ± 0.1% | 29.37 ± 0.1% | not timed | not timed | 600.93 ± 0.5% | | 1.00 | 0.98 | 20.49 |
| imported/rsc/reallyhard0-1mb | 51 | 625.74 ± 0.7% | not timed | not timed | 617.85 ± 0.1% | 29.40 ± 0.1% | not timed | not timed | 626.31 ± 1.0% | | 1.00 | 1.01 | 21.28 |
| imported/rsc/reallyreallyhard0-32 | 47 | 284.54 ± 1.5% | not timed | not timed | 197.71 ± 0.4% | 60.22 ± 15.8% | not timed | not timed | 285.61 ± 1.5% | | 1.00 | 1.44 | 4.72 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7018.22 ± 0.1% | not timed | not timed | 5912.92 ± 0.1% | 33.63 ± 1.6% | not timed | not timed | 6997.48 ± 0.0% | | 1.00 | 1.19 | 208.69 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21429.20 ± 0.1% | not timed | not timed | 19387.36 ± 0.1% | 24.69 ± 1.8% | not timed | not timed | 21430.28 ± 0.2% | | 1.00 | 1.11 | 867.91 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21155.29 ± 1.8% | not timed | not timed | 19328.18 ± 1.8% | 24.74 ± 0.7% | not timed | not timed | 21139.70 ± 1.6% | | 1.00 | 1.09 | 855.11 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 280.79 ± 1.8% | not timed | not timed | 214.18 ± 0.4% | 60.98 ± 13.0% | not timed | not timed | 281.59 ± 1.3% | | 1.00 | 1.31 | 4.60 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5908.66 ± 0.3% | not timed | not timed | 6195.53 ± 0.1% | 34.37 ± 0.7% | not timed | not timed | 5929.23 ± 0.2% | | 1.00 | 0.95 | 171.91 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21332.60 ± 0.2% | not timed | not timed | 19302.15 ± 0.1% | 24.71 ± 2.5% | not timed | not timed | 21367.34 ± 0.0% | | 1.00 | 1.11 | 863.38 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 20764.39 ± 2.0% | not timed | not timed | 19148.82 ± 1.5% | 24.72 ± 0.1% | not timed | not timed | 20716.48 ± 2.5% | | 1.00 | 1.08 | 839.93 |
| imported/sherlock/name-sherlock | 776 | 19374.03 ± 6.1% | not timed | not timed | 18308.69 ± 0.8% | 9845.80 ± 18.0% | not timed | not timed | 19338.74 ± 2.3% | | 1.00 | 1.06 | 1.97 |
| imported/sherlock/name-holmes | 2766 | 14983.26 ± 1.6% | not timed | not timed | 15411.25 ± 1.2% | 3201.80 ± 10.3% | not timed | not timed | 15047.18 ± 1.6% | | 1.00 | 0.97 | 4.68 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19312.39 ± 2.0% | not timed | not timed | 18245.47 ± 1.1% | 7911.60 ± 50.1% | not timed | not timed | 19378.16 ± 1.9% | | 1.00 | 1.06 | 2.44 |
| imported/sherlock/name-sherlock-casei | 816 | 15350.57 ± 0.6% | not timed | not timed | 4014.09 ± 0.1% | 32.29 ± 0.1% | not timed | not timed | 15343.48 ± 0.6% | | 1.00 | 3.82 | 475.41 |
| imported/sherlock/name-holmes-casei | 2802 | 9296.60 ± 5.0% | not timed | not timed | 3321.72 ± 0.2% | 38.26 ± 2.6% | not timed | not timed | 9303.10 ± 1.8% | | 1.00 | 2.80 | 242.97 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12761.68 ± 7.3% | not timed | not timed | 3946.31 ± 0.1% | 32.43 ± 0.2% | not timed | not timed | 12766.51 ± 1.0% | | 1.00 | 3.23 | 393.52 |
| imported/sherlock/name-whitespace | 1461 | 14982.57 ± 1.5% | not timed | not timed | 14429.72 ± 0.4% | 6358.63 ± 19.9% | not timed | not timed | 15057.98 ± 1.6% | | 0.99 | 1.04 | 2.36 |
| imported/sherlock/name-alt1 | 1142 | 11551.21 ± 0.4% | not timed | not timed | 16244.39 ± 1.0% | 4082.51 ± 25.6% | not timed | not timed | 11556.90 ± 3.1% | | 1.00 | 0.71 | 2.83 |
| imported/sherlock/name-alt2 | 3542 | 8917.93 ± 0.8% | not timed | not timed | 3829.04 ± 0.2% | 31.34 ± 0.1% | not timed | not timed | 8909.15 ± 0.6% | | 1.00 | 2.33 | 284.58 |
| imported/sherlock/name-alt3 | 4507 | 5528.07 ± 0.5% | not timed | not timed | 3632.77 ± 0.1% | 9.93 ± 2.0% | not timed | not timed | 5524.89 ± 0.6% | | 1.00 | 1.52 | 556.86 |
| imported/sherlock/name-alt3-casei | 4593 | 1520.90 ± 2.6% | not timed | not timed | 285.34 ± 0.2% | 6.44 ± 0.3% | not timed | not timed | 1526.23 ± 0.4% | | 1.00 | 5.33 | 236.14 |
| imported/sherlock/name-alt4 | 3686 | 6392.15 ± 0.2% | not timed | not timed | 3776.01 ± 0.3% | 31.42 ± 0.1% | not timed | not timed | 6378.39 ± 0.4% | | 1.00 | 1.69 | 203.42 |
| imported/sherlock/name-alt4-casei | 4254 | 2806.12 ± 2.1% | not timed | not timed | 2581.86 ± 0.3% | 19.83 ± 0.2% | not timed | not timed | 2808.64 ± 1.6% | | 1.00 | 1.09 | 141.53 |
| imported/sherlock/name-alt5 | 4028 | 6390.09 ± 0.3% | not timed | not timed | 3742.63 ± 0.1% | 21.82 ± 0.2% | not timed | not timed | 6395.12 ± 0.6% | | 1.00 | 1.71 | 292.90 |
| imported/sherlock/name-alt5-casei | 4104 | 3478.80 ± 1.5% | not timed | not timed | 2234.96 ± 0.2% | 14.32 ± 0.1% | not timed | not timed | 3476.59 ± 0.7% | | 1.00 | 1.56 | 243.02 |
| imported/sherlock/no-match-uncommon | 0 | 21148.84 ± 0.4% | not timed | not timed | 19332.63 ± 0.5% | 34635.89 ± 0.6% | not timed | not timed | 21131.08 ± 0.8% | | 1.00 | 1.09 | 0.61 |
| imported/sherlock/no-match-common | 0 | 20834.29 ± 1.1% | not timed | not timed | 19239.29 ± 0.5% | 1278.76 ± 1.1% | not timed | not timed | 20912.73 ± 0.9% | | 1.00 | 1.08 | 16.29 |
| imported/sherlock/no-match-really-common | 0 | 15868.99 ± 3.9% | not timed | not timed | 18425.67 ± 0.9% | 1281.63 ± 0.7% | not timed | not timed | 15964.96 ± 1.7% | | 0.99 | 0.86 | 12.38 |
| imported/sherlock/the-lower | 21654 | 2303.65 ± 0.9% | not timed | not timed | 2337.61 ± 0.2% | 243.09 ± 14.4% | not timed | not timed | 2309.91 ± 1.7% | | 1.00 | 0.99 | 9.48 |
| imported/sherlock/the-upper | 2223 | 12562.47 ± 1.3% | not timed | not timed | 13496.67 ± 1.5% | 2665.37 ± 16.8% | not timed | not timed | 12673.40 ± 1.3% | | 0.99 | 0.93 | 4.71 |
| imported/sherlock/the-casei | 23961 | 1991.42 ± 0.6% | not timed | not timed | 1313.58 ± 0.3% | 34.93 ± 0.7% | not timed | not timed | 1992.88 ± 0.3% | | 1.00 | 1.52 | 57.01 |
| imported/sherlock/everything-greedy | 581881 | 282.47 ± 0.3% | not timed | not timed | 166.23 ± 0.2% | 28.84 ± 37.9% | not timed | not timed | 281.41 ± 8.1% | | 1.00 | 1.70 | 9.79 |
| imported/sherlock/everything-greedy-nl | 594933 | 490.63 ± 0.2% | not timed | not timed | 213.02 ± 0.7% | 32.88 ± 0.1% | not timed | not timed | 489.32 ± 0.2% | | 1.00 | 2.30 | 14.92 |
| imported/sherlock/letters | 447175 | 61.47 ± 2.3% | not timed | not timed | 33.09 ± 0.1% | 6.43 ± 24.4% | not timed | not timed | 61.62 ± 8.1% | | 1.00 | 1.86 | 9.57 |
| imported/sherlock/letters-upper | 14180 | 448.37 ± 3.6% | not timed | not timed | 279.78 ± 0.7% | 29.48 ± 18.0% | not timed | not timed | 446.53 ± 0.3% | | 1.00 | 1.60 | 15.21 |
| imported/sherlock/letters-lower | 432995 | 62.29 ± 1.1% | not timed | not timed | 33.85 ± 0.1% | 6.89 ± 44.2% | not timed | not timed | 63.02 ± 0.7% | | 0.99 | 1.84 | 9.04 |
| imported/sherlock/words | 447639 | 112.30 ± 6.2% | not timed | not timed | 82.81 ± 0.2% | 13.94 ± 21.3% | not timed | not timed | 113.11 ± 0.3% | | 0.99 | 1.36 | 8.06 |
| imported/sherlock/before-holmes | 4073 | 10206.76 ± 0.4% | not timed | not timed | 8406.25 ± 0.3% | 24.18 ± 0.4% | not timed | not timed | 10211.79 ± 0.3% | | 1.00 | 1.21 | 422.19 |
| imported/sherlock/before-after-holmes | 2593 | 9844.70 ± 0.9% | not timed | not timed | 9503.26 ± 0.6% | 23.91 ± 1.4% | not timed | not timed | 9864.74 ± 1.0% | | 1.00 | 1.04 | 411.76 |
| imported/sherlock/holmes-cochar-watson | 150 | 5164.17 ± 0.1% | not timed | not timed | 3421.47 ± 0.4% | 31.08 ± 0.3% | not timed | not timed | 5175.94 ± 0.3% | | 1.00 | 1.51 | 166.16 |
| imported/sherlock/holmes-coword-watson | 14309 | 1153.98 ± 0.2% | not timed | not timed | 1121.43 ± 0.2% | 6.72 ± 0.3% | not timed | not timed | 1150.86 ± 0.2% | | 1.00 | 1.03 | 171.78 |
| imported/sherlock/quotes | 14437 | 1570.73 ± 0.2% | not timed | not timed | 1752.42 ± 0.3% | 35.18 ± 0.2% | not timed | not timed | 1573.71 ± 0.2% | | 1.00 | 0.90 | 44.64 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17011.92 ± 0.5% | not timed | not timed | 15907.80 ± 0.7% | 36.71 ± 0.1% | not timed | not timed | 17101.52 ± 0.6% | | 0.99 | 1.07 | 463.36 |
| imported/sherlock/word-ending-n | 35297 | 480.54 ± 2.1% | not timed | not timed | 409.14 ± 0.1% | 23.62 ± 18.1% | not timed | not timed | 480.51 ± 0.7% | | 1.00 | 1.17 | 20.34 |
| imported/sherlock/repeated-class-negation | 2130 | 14594.48 ± 0.5% | not timed | not timed | 10827.75 ± 0.3% | 11.61 ± 0.1% | not timed | not timed | 14642.00 ± 0.4% | | 1.00 | 1.35 | 1257.53 |
| imported/sherlock/ing-suffix | 20547 | 559.01 ± 0.3% | not timed | not timed | 516.75 ± 0.1% | 28.83 ± 0.0% | not timed | not timed | 559.23 ± 0.5% | | 1.00 | 1.08 | 19.39 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1670.35 ± 0.2% | not timed | not timed | 2080.95 ± 0.6% | 20.53 ± 0.2% | not timed | not timed | 1669.98 ± 0.5% | | 1.00 | 0.80 | 81.37 |
| opt/accelerate/whole-line | 239963 | 457.23 ± 0.4% | not timed | not timed | 374.16 ± 0.5% | 91.46 ± 15.8% | not timed | not timed | 457.27 ± 0.2% | | 1.00 | 1.22 | 5.00 |
| opt/accelerate/non-dna | 16745 | 431.47 ± 0.7% | not timed | not timed | 400.48 ± 0.1% | 29.27 ± 52.1% | not timed | not timed | 431.13 ± 0.4% | | 1.00 | 1.08 | 14.74 |
| opt/backtrack/words-english | 40536 | 141.44 ± 1.5% | not timed | not timed | 94.42 ± 0.1% | 19.56 ± 7.0% | not timed | not timed | 141.50 ± 2.1% | | 1.00 | 1.50 | 7.23 |
| opt/fixed-length/too-small-ascii | 0 | 311.09 ± 0.3% | not timed | not timed | 700.27 ± 0.3% | 80.78 ± 0.9% | not timed | not timed | 317.30 ± 0.8% | | 0.98 | 0.44 | 3.85 |
| opt/fixed-length/too-big-ascii | 0 | 3464.67 ± 0.2% | not timed | not timed | 5808.01 ± 1.5% | 124.82 ± 1.4% | not timed | not timed | 3454.11 ± 0.2% | | 1.00 | 0.60 | 27.76 |
| opt/fixed-length/go33484-1 | 0 | 665779.08 ± 0.2% | not timed | not timed | 1099554.25 ± 1.0% | 61451.40 ± 0.2% | not timed | not timed | 665492.92 ± 0.2% | | 1.00 | 0.61 | 10.83 |
| opt/fixed-length/go33484-2 | 0 | 665362.18 ± 0.2% | not timed | not timed | 1108254.25 ± 0.5% | 32325.93 ± 1.1% | not timed | not timed | 666086.64 ± 0.2% | | 1.00 | 0.60 | 20.58 |
| opt/fixed-length/go33484-3 | 0 | 66516.14 ± 0.7% | not timed | not timed | 111464.94 ± 1.5% | 770.94 ± 0.3% | not timed | not timed | 66563.89 ± 0.6% | | 1.00 | 0.60 | 86.28 |
| opt/literal-alt/one-pattern | 1 | 548.01 ± 1.7% | not timed | not timed | 537.03 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 546.64 ± 1.6% | | 1.00 | 1.02 | 1378.57 |
| opt/onepass/fn-predicate | 916 | 366.83 ± 0.9% | not timed | not timed | 336.82 ± 0.2% | 203.46 ± 13.9% | not timed | not timed | 370.82 ± 0.1% | | 0.99 | 1.09 | 1.80 |
| opt/onepass/first-three-words-english | 35128 | 179.42 ± 7.9% | not timed | not timed | 201.13 ± 0.1% | 79.40 ± 9.4% | not timed | not timed | 181.90 ± 1.0% | | 0.99 | 0.89 | 2.26 |
| opt/prefilter/literal-english | 1 | 21023.87 ± 0.5% | not timed | not timed | 20222.90 ± 0.2% | 17639.02 ± 0.8% | not timed | not timed | 21052.75 ± 0.2% | | 1.00 | 1.04 | 1.19 |
| opt/prefilter/literal-casei-english | 1 | 14604.22 ± 0.7% | not timed | not timed | 4313.72 ± 0.1% | 32.66 ± 0.1% | not timed | not timed | 14633.38 ± 0.2% | | 1.00 | 3.39 | 447.21 |
| opt/prefilter/literal-russian | 1 | 21299.88 ± 0.6% | not timed | not timed | 19989.40 ± 0.4% | 3326.02 ± 0.3% | not timed | not timed | 21304.89 ± 0.3% | | 1.00 | 1.07 | 6.40 |
| opt/prefilter/literal-casei-russian | 1 | 8554.05 ± 0.4% | not timed | not timed | 3892.64 ± 0.1% | 31.72 ± 0.4% | not timed | not timed | 8554.22 ± 0.4% | | 1.00 | 2.20 | 269.67 |
| opt/prefilter/rust-functions | 948 | 6809.65 ± 0.3% | not timed | not timed | 8915.55 ± 0.3% | 1868.80 ± 0.3% | not timed | not timed | 6813.31 ± 0.2% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 29649882.61 ± 0.2% | not timed | not timed | 21593324.57 ± 0.4% | 50.30 ± 0.5% | not timed | not timed | 29663255.92 ± 0.2% | | 1.00 | 1.37 | 589427.03 |
| opt/reverse-inner/holmes | 2593 | 9847.86 ± 0.7% | not timed | not timed | 9475.18 ± 0.3% | 24.06 ± 1.7% | not timed | not timed | 9879.75 ± 0.6% | | 1.00 | 1.04 | 409.32 |
| opt/reverse-inner/email | 47 | 36287.61 ± 2.2% | not timed | not timed | 44906.21 ± 0.9% | 32.43 ± 0.1% | not timed | not timed | 36758.48 ± 2.1% | | 0.99 | 0.81 | 1119.04 |
| opt/reverse-inner/factored-prefix | 3542 | 593.52 ± 0.3% | not timed | not timed | 594.49 ± 0.1% | 12.54 ± 0.1% | not timed | not timed | 591.68 ± 0.5% | | 1.00 | 1.00 | 47.35 |
| opt/reverse-inner/no-quadratic-backward | 0 | 20970.68 ± 0.1% | not timed | not timed | 617.01 ± 0.1% | 74.99 ± 0.0% | not timed | not timed | 21140.95 ± 0.2% | | 0.99 | 33.99 | 279.64 |
| opt/reverse-inner/no-quadratic-forward | 0 | 728.01 ± 2.1% | not timed | not timed | 288.35 ± 0.2% | 24.65 ± 0.1% | not timed | not timed | 736.38 ± 1.4% | | 0.99 | 2.52 | 29.54 |
| opt/reverse-suffix/holmes | 4073 | 10192.20 ± 0.5% | not timed | not timed | 8392.82 ± 0.4% | 23.81 ± 2.5% | not timed | not timed | 10202.81 ± 0.4% | | 1.00 | 1.21 | 428.07 |
| opt/reverse-suffix/no-quadratic | 0 | 21062.08 ± 0.1% | not timed | not timed | 616.68 ± 0.6% | 74.93 ± 0.1% | not timed | not timed | 21139.76 ± 0.2% | | 1.00 | 34.15 | 281.08 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.66 ± 8.7% | not timed | not timed | 132.54 ± 0.3% | 13.17 ± 16.7% | not timed | not timed | 120.52 ± 3.0% | | 1.00 | 0.91 | 9.17 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 119.38 ± 3.0% | not timed | not timed | 131.31 ± 0.1% | 12.93 ± 12.8% | not timed | not timed | 120.44 ± 0.8% | | 0.99 | 0.91 | 9.23 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.1% | not timed | not timed | 0.54 ± 0.2% | 112.50 ± 0.5% | not timed | not timed | 0.28 ± 0.4% | | 0.99 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 320.62 ± 0.2% | not timed | not timed | 294.91 ± 0.1% | 103.25 ± 8.3% | not timed | not timed | 318.70 ± 3.2% | | 1.01 | 1.09 | 3.11 |
| reported/i13-subset-regex/original-ascii | 4094 | 11214.62 ± 0.7% | not timed | not timed | 4501.21 ± 0.3% | 11.50 ± 0.2% | not timed | not timed | 11250.55 ± 1.0% | | 1.00 | 2.49 | 975.12 |
| reported/i13-subset-regex/original-unicode | 4094 | 11083.18 ± 0.9% | not timed | not timed | 252.52 ± 2.8% | 11.52 ± 0.1% | not timed | not timed | 11254.39 ± 0.6% | | 0.98 | 43.89 | 962.08 |
| reported/i13-subset-regex/big-ascii | 1955 | 10729.29 ± 1.0% | not timed | not timed | 67.85 ± 3.6% | 9.84 ± 0.0% | not timed | not timed | 10770.31 ± 0.9% | | 1.00 | 158.14 | 1090.18 |
| reported/i13-subset-regex/big-unicode | 1955 | 10590.36 ± 1.0% | not timed | not timed | 12.24 ± 54.9% | 9.86 ± 0.1% | not timed | not timed | 10731.85 ± 1.1% | | 0.99 | 865.41 | 1074.41 |
| reported/i13-subset-regex/huge-ascii | 55 | 10082.95 ± 2.8% | not timed | not timed | 11.08 ± 0.1% | 8.74 ± 0.2% | not timed | not timed | 10042.16 ± 2.8% | | 1.00 | 910.36 | 1154.21 |
| reported/i13-subset-regex/huge-unicode | 55 | 9921.67 ± 2.6% | not timed | not timed | 11.00 ± 0.4% | 8.75 ± 0.1% | not timed | not timed | 9875.36 ± 2.1% | | 1.00 | 902.09 | 1134.39 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.1% | not timed | not timed | 11.01 ± 0.1% | 8.72 ± 0.1% | not timed | not timed | 3.53 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.2% | not timed | not timed | 10.94 ± 0.4% | 8.74 ± 0.8% | not timed | not timed | 4.97 ± 0.1% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.57 ± 0.4% | not timed | not timed | 104.57 ± 0.1% | 6.57 ± 0.2% | not timed | not timed | 484.21 ± 0.3% | | 1.00 | 4.62 | 73.65 |
| reported/i787-keywords/opt-ascii | 5674 | 485.26 ± 0.4% | not timed | not timed | 273.88 ± 0.2% | 10.30 ± 0.1% | not timed | not timed | 482.89 ± 0.7% | | 1.00 | 1.77 | 47.11 |
| slow/quadratic-regex-1x | 100 | 7.08 ± 0.5% | not timed | not timed | 4.95 ± 0.4% | 0.05 ± 0.2% | not timed | not timed | 7.13 ± 0.7% | | 0.99 | 1.43 | 143.69 |
| slow/quadratic-regex-2x | 199 | 3.41 ± 0.2% | not timed | not timed | 2.66 ± 0.5% | 0.01 ± 0.2% | not timed | not timed | 3.42 ± 0.1% | | 1.00 | 1.28 | 270.07 |
| slow/quadratic-haystack-1x | 100 | 22.06 ± 7.3% | not timed | not timed | 10.03 ± 0.2% | 1.01 ± 13.1% | not timed | not timed | 21.99 ± 1.5% | | 1.00 | 2.20 | 21.85 |
| slow/quadratic-haystack-2x | 200 | 19.62 ± 1.1% | not timed | not timed | 5.53 ± 0.2% | 0.54 ± 0.7% | not timed | not timed | 19.60 ± 7.3% | | 1.00 | 3.55 | 36.02 |
| unicode/codepoints/any-one | 1112064 | 281.68 ± 1.4% | not timed | not timed | 175.01 ± 0.3% | 17.88 ± 31.7% | not timed | not timed | 282.33 ± 0.4% | | 1.00 | 1.61 | 15.76 |
| unicode/codepoints/any-all | 4382592 | 280.90 ± 1.3% | not timed | not timed | 246.94 ± 0.1% | 117.25 ± 0.1% | not timed | not timed | 282.09 ± 1.0% | | 1.00 | 1.14 | 2.40 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.70 ± 0.8% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 604.15 ± 0.6% | not timed | not timed | 615.58 ± 0.3% | 135.35 ± 0.1% | not timed | not timed | 601.20 ± 0.8% | | 1.00 | 0.98 | 4.46 |
| unicode/overlapping-words/ascii | 6156 | 32.28 ± 0.3% | not timed | not timed | 38.82 ± 0.3% | 3.88 ± 16.1% | not timed | not timed | 32.35 ± 12.6% | | 1.00 | 0.83 | 8.31 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.1% | not timed | not timed | 4.11 ± 0.2% | 2.37 ± 6.9% | not timed | not timed | 1.43 ± 1.2% | | 1.01 | 0.35 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 1.0% | not timed | not timed | 4.08 ± 0.4% | 6.32 ± 7.6% | not timed | not timed | 1.28 ± 0.2% | | 1.00 | 0.31 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 129.12 ± 2.4% | not timed | not timed | 83.05 ± 0.3% | 12.29 ± 22.6% | not timed | not timed | 129.39 ± 9.3% | | 1.00 | 1.55 | 10.51 |
| unicode/word/boundary-long-english | 3466 | 606.53 ± 0.3% | not timed | not timed | 604.76 ± 0.2% | 32.37 ± 0.9% | not timed | not timed | 604.95 ± 0.4% | | 1.00 | 1.00 | 18.74 |
| unicode/word/around-holmes-english | 27 | 20068.34 ± 0.1% | not timed | not timed | 19947.56 ± 0.4% | 22.28 ± 0.7% | not timed | not timed | 20196.86 ± 0.3% | | 0.99 | 1.01 | 900.84 |
| wild/bibleref/long | 874 | 564.94 ± 0.1% | not timed | not timed | 583.94 ± 0.1% | 6.54 ± 0.2% | not timed | not timed | 566.76 ± 0.1% | | 1.00 | 0.97 | 86.44 |
| wild/bibleref/short | 30 | 24.03 ± 2.3% | not timed | not timed | 31.05 ± 0.2% | 14.55 ± 11.5% | not timed | not timed | 24.40 ± 6.1% | | 0.98 | 0.77 | 1.65 |
| wild/bibleref/line | 874 | 398.88 ± 1.7% | not timed | not timed | 211.59 ± 0.3% | 9.21 ± 8.3% | not timed | not timed | 400.02 ± 0.1% | | 1.00 | 1.89 | 43.31 |
| wild/caddy/caddy | 6 | 420.65 ± 6.8% | not timed | not timed | 250.34 ± 0.1% | 68.59 ± 12.7% | not timed | not timed | 422.00 ± 0.4% | | 1.00 | 1.68 | 6.13 |
| wild/dot-star-capture/rust-src-tools | 6 | 1069.80 ± 0.3% | not timed | not timed | 343.54 ± 0.7% | 13.51 ± 0.2% | not timed | not timed | 1064.34 ± 0.3% | | 1.01 | 3.11 | 79.18 |
| wild/ruff/noqa | 84 | 438.62 ± 0.2% | not timed | not timed | 460.95 ± 0.1% | 19.72 ± 1.5% | not timed | not timed | 438.82 ± 0.2% | | 1.00 | 0.95 | 22.25 |
| wild/ruff/unnecessary-coding-comment | 16 | 957.28 ± 0.4% | not timed | not timed | 699.75 ± 0.3% | 136.38 ± 11.3% | not timed | not timed | 959.38 ± 0.5% | | 1.00 | 1.37 | 7.02 |
| wild/ruff/string-quote-prefix | 2972 | 1365.25 ± 0.6% | not timed | not timed | 406.53 ± 0.1% | 316.67 ± 25.1% | not timed | not timed | 1365.83 ± 0.6% | | 1.00 | 3.36 | 4.31 |
| wild/ruff/space-around-operator | 1224378 | 223.23 ± 1.8% | not timed | not timed | 186.77 ± 0.1% | 18.38 ± 1.5% | not timed | not timed | 223.80 ± 1.8% | | 1.00 | 1.20 | 12.14 |
| wild/ruff/shebang | 282 | 972.25 ± 0.5% | not timed | not timed | 328.41 ± 0.1% | 111.80 ± 11.4% | not timed | not timed | 978.27 ± 0.4% | | 0.99 | 2.96 | 8.70 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13821.33 ± 0.6% | not timed | not timed | 13862.30 ± 0.6% | 6944.66 ± 0.8% | not timed | not timed | 13837.40 ± 0.4% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12839.39 ± 0.3% | not timed | not timed | 13407.61 ± 0.5% | 6412.97 ± 0.7% | not timed | not timed | 12839.12 ± 0.5% | | 1.00 | 0.96 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13198.85 ± 0.7% | not timed | not timed | 13648.52 ± 0.6% | 6630.43 ± 1.1% | not timed | not timed | 13206.86 ± 0.7% | | 1.00 | 0.97 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9571.17 ± 0.2% | not timed | not timed | 13556.17 ± 0.6% | 6735.17 ± 0.7% | not timed | not timed | 9574.96 ± 0.3% | | 1.00 | 0.71 | 1.42 |
| wild/url/search | 234965 | 121.08 ± 14.0% | not timed | not timed | 65.40 ± 0.3% | 2.21 ± 0.5% | not timed | not timed | 120.16 ± 14.1% | | 1.01 | 1.85 | 54.80 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 11.3% | not timed | not timed | 0.01 ± 1.4% | 0.01 ± 16.4% | not timed | not timed | 0.03 ± 10.9% | | 0.99 | 3.09 | 3.64 |
| dictionary/compile/english-15 | 1 | 0.35 ± 20.0% | not timed | not timed | 0.07 ± 12.5% | 0.10 ± 17.5% | not timed | not timed | 0.35 ± 3.1% | | 1.00 | 5.19 | 3.46 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 11.2% | not timed | not timed | 0.02 ± 1.5% | 35.68 ± 7.4% | not timed | not timed | 0.25 ± 2.7% | | 1.01 | 13.13 | 0.0071 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.78 ± 1.8% | not timed | not timed | 11.58 ± 0.2% | 62.05 ± 18.3% | not timed | not timed | 47.84 ± 1.7% | | 1.00 | 4.13 | 0.77 |
| reported/i787-keywords/compile | 1 | 35.58 ± 1.0% | not timed | not timed | 2.11 ± 1.4% | 16.38 ± 21.9% | not timed | not timed | 35.59 ± 3.2% | | 1.00 | 16.89 | 2.17 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 360.52 ± 23.8% | not timed | not timed | 121.37 ± 0.2% | 563.57 ± 14.7% | not timed | not timed | 364.43 ± 1.0% | | 0.99 | 2.97 | 0.64 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.96 ± 1.5% | not timed | not timed | 4.08 ± 0.5% | 43.96 ± 12.7% | not timed | not timed | 48.56 ± 3.1% | | 0.99 | 11.75 | 1.09 |
| unicode/compile/one-letter | 53 | 6.79 ± 2.6% | not timed | not timed | 4.54 ± 0.7% | 66.99 ± 9.1% | not timed | not timed | 6.78 ± 13.5% | | 1.00 | 1.50 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.08 ± 16.9% | not timed | not timed | 0.10 ± 0.9% | 66.73 ± 9.7% | not timed | not timed | 1.10 ± 1.3% | | 0.98 | 10.88 | 0.0162 |
| unicode/compile/fifty-letters-ascii | 1 | 219.48 ± 2.7% | not timed | not timed | 52.77 ± 0.2% | 200.28 ± 35.9% | not timed | not timed | 223.58 ± 0.4% | | 0.98 | 4.16 | 1.10 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 382.06 ± 7.7% | not timed | not timed | 46.90 ± 1.1% | 680.64 ± 27.1% | not timed | not timed | 387.78 ± 0.9% | | 0.99 | 8.15 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 616.50 ± 13.4% | not timed | not timed | 145.02 ± 0.4% | 686.35 ± 19.7% | not timed | not timed | 615.53 ± 3.7% | | 1.00 | 4.25 | 0.90 |
| unicode/compile/negated-class-matches-codepoint | 1 | 331.20 ± 13.2% | not timed | not timed | 51.37 ± 0.6% | 1258.06 ± 30.4% | not timed | not timed | 331.88 ± 5.9% | | 1.00 | 6.45 | 0.26 |
| wild/bibleref/compile | 3 | 5.83 ± 7.1% | not timed | not timed | 1.91 ± 0.7% | 33.07 ± 11.0% | not timed | not timed | 5.96 ± 18.0% | | 0.98 | 3.04 | 0.18 |
| wild/url/compile | 1 | 0.65 ± 17.6% | not timed | not timed | 0.14 ± 0.9% | 0.47 ± 37.0% | not timed | not timed | 0.66 ± 21.4% | | 0.99 | 4.52 | 1.40 |

