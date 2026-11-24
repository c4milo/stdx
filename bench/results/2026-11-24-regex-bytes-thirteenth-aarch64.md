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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391545218 |
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
| literal: a word | 217 | 19749.37 ± 3.8% | 5038.42 ± 0.3% | 28.12 ± 0.3% | 18274.95 ± 3.0% | 9198.13 ± 7.9% | 17.46 ± 0.3% | 84.47 ± 0.7% | 19563.09 ± 3.6% | 3.92 | 1.01 | 1.08 | 2.15 |
| literal: a word that is not there | 0 | 21760.44 ± 1.7% | 4928.77 ± 0.4% | 28.17 ± 0.5% | 19763.79 ± 2.6% | 29290.34 ± 3.4% | 17.28 ± 0.6% | 79.84 ± 0.3% | 21679.60 ± 1.1% | 4.41 | 1.00 | 1.10 | 0.74 |
| literal: one of four words | 661 | 6360.21 ± 0.2% | 1948.48 ± 0.1% | 14.26 ± 0.2% | 3951.98 ± 0.1% | 21.86 ± 0.3% | 5.26 ± 0.2% | 6.75 ± 3.6% | 6357.01 ± 0.5% | 3.26 | 1.00 | 1.61 | 290.91 |
| literal: a word in any case | 217 | 15172.82 ± 0.8% | 2087.50 ± 0.9% | 21.25 ± 0.2% | 3974.48 ± 0.2% | 37.95 ± 1.1% | refused | differs | 15178.66 ± 0.7% | 7.27 | 1.00 | 3.82 | 399.86 |
| literal: an href attribute | 33 | 16681.64 ± 0.9% | 608.86 ± 0.6% | 26.74 ± 0.3% | 16921.52 ± 2.3% | 2263.22 ± 0.9% | 13.33 ± 0.1% | 74.14 ± 0.4% | 16738.15 ± 1.4% | 27.40 | 1.00 | 0.99 | 7.37 |
| literal: a word, second text | 123 | 19702.92 ± 3.5% | 3391.71 ± 0.2% | 27.68 ± 0.2% | 18017.31 ± 2.2% | 7708.36 ± 9.1% | 19.66 ± 0.3% | 70.51 ± 0.2% | 19655.84 ± 2.3% | 5.81 | 1.00 | 1.09 | 2.56 |
| class: two capitalized words | 1331 | 1069.77 ± 0.3% | 598.86 ± 0.2% | 25.75 ± 0.4% | 585.75 ± 0.0% | 40.69 ± 7.6% | 14.82 ± 0.4% | 67.56 ± 0.4% | 1071.55 ± 0.5% | 1.79 | 1.00 | 1.83 | 26.29 |
| class: a word that ends in ing | 3399 | 572.97 ± 0.1% | 573.22 ± 0.3% | 17.80 ± 0.1% | 547.76 ± 0.1% | 29.63 ± 3.5% | 8.18 ± 0.1% | 18.41 ± 0.1% | 573.85 ± 0.1% | 1.00 | 1.00 | 1.05 | 19.33 |
| class: a word in capitals | 2332 | 1378.68 ± 0.1% | 604.86 ± 0.2% | 26.87 ± 0.3% | 572.40 ± 0.1% | 43.59 ± 3.1% | 17.17 ± 0.2% | 82.52 ± 0.3% | 1379.74 ± 0.5% | 2.28 | 1.00 | 2.41 | 31.63 |
| class: a number | 8288 | 1997.78 ± 0.2% | 828.31 ± 0.2% | 27.55 ± 0.1% | 1735.11 ± 0.2% | 42.93 ± 7.4% | 0.56 ± 0.2% | 57.49 ± 0.1% | 1997.24 ± 0.2% | 2.41 | 1.00 | 1.15 | 46.54 |
| class: two capitalized words, second text | 5359 | 515.72 ± 0.2% | 523.94 ± 0.2% | 23.06 ± 0.1% | 485.61 ± 0.1% | 34.46 ± 13.5% | 16.63 ± 0.5% | 62.92 ± 0.5% | 516.34 ± 0.1% | 0.98 | 1.00 | 1.06 | 14.97 |
| other: a word between two words | 6104 | 790.91 ± 0.3% | 592.96 ± 0.2% | 23.26 ± 0.1% | 737.08 ± 0.1% | 108.87 ± 20.3% | 11.31 ± 0.1% | 68.31 ± 0.3% | 791.75 ± 0.1% | 1.33 | 1.00 | 1.07 | 7.26 |
| other: a number before a unit, second text | 1481 | 5968.11 ± 0.5% | 1119.97 ± 0.2% | 25.87 ± 0.2% | 5645.51 ± 0.7% | 40.79 ± 7.6% | 17.81 ± 0.4% | 65.83 ± 0.1% | 5953.77 ± 1.1% | 5.33 | 1.00 | 1.06 | 146.31 |
| other: a heading's start tag | 110 | 13945.24 ± 1.4% | 743.27 ± 0.2% | 27.17 ± 0.1% | 1708.32 ± 0.6% | 1575.06 ± 3.6% | 16.24 ± 0.6% | 86.10 ± 0.6% | 14059.68 ± 1.8% | 18.76 | 0.99 | 8.16 | 8.85 |
| other: a whole word | 217 | 15857.47 ± 1.3% | 603.21 ± 0.6% | 28.91 ± 0.4% | 14689.59 ± 1.3% | 49.41 ± 0.2% | 13.60 ± 0.1% | 54.86 ± 0.3% | 15902.31 ± 0.6% | 26.29 | 1.00 | 1.08 | 320.93 |
| other: a line's first word, second text | 3716 | 2032.51 ± 0.3% | 587.59 ± 0.2% | 30.48 ± 0.3% | 1717.75 ± 0.5% | 63.44 ± 6.8% | refused | refused | 2046.72 ± 0.9% | 3.46 | 0.99 | 1.18 | 32.04 |
| other: fourteen octets before an x | 87 | 24175.91 ± 1.3% | 254.08 ± 0.6% | 6.30 ± 0.1% | 3958.12 ± 1.3% | 10.65 ± 0.2% | differs | 17.76 ± 0.3% | 23925.76 ± 7.7% | 95.15 | 1.01 | 6.11 | 2269.50 |
| other: a Greek word | 21815 | 496.27 ± 0.3% | 413.74 ± 0.3% | 30.59 ± 0.2% | 289.52 ± 0.3% | 49.54 ± 11.7% | differs | refused | 500.39 ± 0.3% | 1.20 | 0.99 | 1.71 | 10.02 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.58 ± 0.3% | 19.54 ± 0.3% | 0.85 ± 0.2% | 19.80 ± 0.4% | 2.78 ± 0.4% | differs | 4.05 ± 0.1% | 19.55 ± 0.2% | 1.00 | 1.00 | 0.99 | 7.05 |
| a UUID | 32895 | 21.10 ± 0.3% | 21.09 ± 0.1% | 0.64 ± 0.2% | 15.15 ± 0.7% | 3.11 ± 0.7% | 0.72 ± 0.2% | 3.64 ± 0.4% | 21.10 ± 0.1% | 1.00 | 1.00 | 1.39 | 6.79 |
| an IPv4 address | 33176 | 35.94 ± 0.2% | 35.84 ± 0.1% | 2.05 ± 0.1% | 28.95 ± 0.5% | 6.67 ± 0.1% | differs | 4.16 ± 0.2% | 35.88 ± 0.2% | 1.00 | 1.00 | 1.24 | 5.39 |
| a date and time | 32954 | 30.91 ± 0.3% | 31.05 ± 0.5% | 1.43 ± 0.3% | 21.14 ± 0.7% | 7.03 ± 0.3% | 1.19 ± 0.3% | 7.13 ± 0.5% | 31.05 ± 0.6% | 1.00 | 1.00 | 1.46 | 4.40 |
| a field path | 32606 | 23.18 ± 0.4% | 23.13 ± 0.4% | 1.01 ± 0.1% | 23.05 ± 0.5% | 3.49 ± 0.7% | differs | 2.98 ± 0.2% | 23.09 ± 0.2% | 1.00 | 1.00 | 1.01 | 6.65 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.17 ± 0.8% | 11.20 ± 1.2% | 11.18 ± 0.7% | 11.38 ± 0.1% | 4.99 ± 1.1% | 0.90 ± 0.6% | none | 11.21 ± 0.6% | 1.00 | 1.00 | 0.98 | 2.24 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 218.42 ± 0.2% | 219.76 ± 0.1% | 261.95 ± 0.1% | 86.28 ± 0.5% | 222.27 ± 1.6% | 483.94 ± 0.8% | 3778.21 ± 4.0% | 218.60 ± 0.1% | 0.99 | 1.00 | 2.53 | 0.98 |
| a UUID | 62 | 143.64 ± 0.6% | 144.32 ± 0.3% | 162.37 ± 0.1% | 45.98 ± 0.9% | 99.80 ± 1.5% | 188.52 ± 2.7% | 4160.36 ± 0.8% | 143.78 ± 0.5% | 1.00 | 1.00 | 3.12 | 1.44 |
| an IPv4 address | 29 | 409.17 ± 0.9% | 414.24 ± 0.2% | 593.98 ± 0.4% | 77.14 ± 0.8% | 132.26 ± 1.4% | 293.85 ± 0.4% | 7445.95 ± 0.5% | 409.61 ± 0.3% | 0.99 | 1.00 | 5.30 | 3.09 |
| a date and time | 56 | 296.50 ± 0.1% | 299.36 ± 0.1% | 382.55 ± 0.5% | 72.12 ± 0.3% | 138.07 ± 2.1% | 326.97 ± 1.8% | 4747.25 ± 0.4% | 296.31 ± 0.3% | 0.99 | 1.00 | 4.11 | 2.15 |
| a field path | 39 | 204.64 ± 0.3% | 205.55 ± 0.1% | 242.19 ± 0.3% | 78.91 ± 2.1% | 206.14 ± 1.1% | 504.16 ± 3.6% | 4677.36 ± 0.7% | 204.68 ± 0.1% | 1.00 | 1.00 | 2.59 | 0.99 |
| literal: a word | 7 | 603.94 ± 0.4% | 653.04 ± 0.3% | 1223.86 ± 0.7% | 499.85 ± 0.2% | 632.34 ± 1.3% | 966.97 ± 0.5% | 29816.79 ± 0.1% | 605.03 ± 0.4% | 0.92 | 1.00 | 1.21 | 0.96 |
| literal: a word that is not there | 8 | 580.42 ± 0.5% | 632.65 ± 0.2% | 1151.52 ± 0.6% | 457.20 ± 0.1% | 604.94 ± 1.2% | 913.95 ± 0.4% | 28793.44 ± 0.2% | 580.73 ± 0.4% | 0.92 | 1.00 | 1.27 | 0.96 |
| literal: one of four words | 26 | 236.25 ± 0.4% | 386.37 ± 0.3% | 539.87 ± 0.2% | 49.42 ± 0.6% | 244.86 ± 2.3% | 373.27 ± 0.7% | 15814.75 ± 0.1% | 236.40 ± 0.2% | 0.61 | 1.00 | 4.78 | 0.96 |
| literal: a word in any case | 11 | 439.07 ± 0.3% | 468.06 ± 0.5% | 713.60 ± 0.1% | 15.48 ± 0.3% | 648.62 ± 1.0% | refused | 23456.88 ± 0.6% | 439.66 ± 0.3% | 0.94 | 1.00 | 28.36 | 0.68 |
| literal: an href attribute | 12 | 330.09 ± 0.4% | 342.01 ± 0.3% | 459.24 ± 0.2% | 12.18 ± 27.5% | 497.84 ± 3.3% | 777.18 ± 0.2% | 21356.34 ± 0.2% | 329.93 ± 0.3% | 0.97 | 1.00 | 27.09 | 0.66 |
| literal: a word, second text | 10 | 541.63 ± 0.5% | 595.83 ± 0.4% | 1037.29 ± 0.7% | 411.04 ± 2.5% | 539.92 ± 1.9% | 800.25 ± 0.4% | 26733.49 ± 0.3% | 541.70 ± 0.2% | 0.91 | 1.00 | 1.32 | 1.00 |
| class: two capitalized words | 23 | 423.98 ± 0.3% | 453.51 ± 0.7% | 672.86 ± 0.3% | 99.51 ± 0.4% | 505.74 ± 2.4% | 748.31 ± 0.5% | 6416.74 ± 0.5% | 424.46 ± 0.6% | 0.93 | 1.00 | 4.26 | 0.84 |
| class: a word that ends in ing | 9 | 534.81 ± 0.3% | 599.44 ± 0.8% | 1087.91 ± 0.1% | 133.06 ± 1.2% | 759.25 ± 0.7% | 1138.11 ± 0.5% | 15772.64 ± 0.2% | 535.42 ± 0.4% | 0.89 | 1.00 | 4.02 | 0.70 |
| class: a word in capitals | 16 | 475.23 ± 0.2% | 517.01 ± 0.4% | 844.45 ± 0.3% | 136.97 ± 0.7% | 755.72 ± 1.2% | 1054.33 ± 0.8% | 8470.67 ± 0.1% | 474.45 ± 0.4% | 0.92 | 1.00 | 3.47 | 0.63 |
| class: a number | 6 | 600.72 ± 0.5% | 667.45 ± 0.2% | 1302.62 ± 0.1% | 41.91 ± 1.2% | 1418.02 ± 1.0% | 1869.31 ± 2.3% | 22514.26 ± 0.1% | 599.94 ± 0.7% | 0.90 | 1.00 | 14.33 | 0.42 |
| class: two capitalized words, second text | 23 | 424.41 ± 0.2% | 455.12 ± 0.4% | 674.17 ± 0.4% | 101.33 ± 0.2% | 508.01 ± 0.7% | 773.84 ± 1.0% | 6419.54 ± 0.4% | 424.30 ± 0.3% | 0.93 | 1.00 | 4.19 | 0.84 |
| other: a word between two words | 13 | 521.15 ± 0.6% | 540.11 ± 0.5% | 893.81 ± 0.1% | 132.99 ± 1.7% | 505.05 ± 1.5% | 819.91 ± 0.8% | 14364.97 ± 0.7% | 520.75 ± 0.3% | 0.96 | 1.00 | 3.92 | 1.03 |
| other: a number before a unit, second text | 15 | 377.48 ± 0.2% | 413.91 ± 0.5% | 591.98 ± 0.1% | 39.50 ± 1.0% | 636.23 ± 3.3% | 896.67 ± 0.6% | 15060.37 ± 0.5% | 377.02 ± 0.5% | 0.91 | 1.00 | 9.56 | 0.59 |
| other: a heading's start tag | 13 | 343.73 ± 1.0% | 351.22 ± 0.2% | 470.99 ± 0.2% | 10.27 ± 28.0% | 630.24 ± 0.8% | 871.07 ± 0.2% | 17807.10 ± 0.5% | 344.14 ± 0.2% | 0.98 | 1.00 | 33.47 | 0.55 |
| other: a whole word | 11 | 558.71 ± 0.4% | 595.48 ± 0.5% | 1033.33 ± 0.3% | 118.67 ± 0.6% | 572.59 ± 1.9% | 836.07 ± 0.8% | 26688.42 ± 0.5% | 558.51 ± 0.3% | 0.94 | 1.00 | 4.71 | 0.98 |
| other: a line's first word, second text | 17 | 508.68 ± 0.1% | 532.46 ± 0.5% | 880.65 ± 0.6% | 127.92 ± 0.1% | 715.95 ± 1.6% | refused | refused | 509.20 ± 0.9% | 0.96 | 1.00 | 3.98 | 0.71 |
| other: fourteen octets before an x | 16 | 107.84 ± 1.7% | 153.71 ± 1.2% | 179.95 ± 1.2% | 6.95 ± 18.1% | 456.64 ± 0.3% | 410.82 ± 0.7% | 12665.73 ± 2.4% | 107.90 ± 0.7% | 0.70 | 1.00 | 15.52 | 0.24 |
| other: a Greek word | 8 | 413.95 ± 0.4% | 563.73 ± 0.5% | 971.37 ± 0.1% | 12.78 ± 61.4% | 1391.07 ± 0.7% | 1847.15 ± 0.5% | refused | 414.03 ± 0.3% | 0.73 | 1.00 | 32.38 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15636.52 ± 1.9% | not timed | not timed | 16220.18 ± 1.0% | 2221.21 ± 20.6% | not timed | not timed | 15586.23 ± 1.0% | | 1.00 | 0.96 | 7.04 |
| 01-literal/sherlock-casei-en | 522 | 11074.00 ± 6.1% | not timed | not timed | 3593.70 ± 0.1% | 32.53 ± 0.1% | not timed | not timed | 11074.60 ± 1.2% | | 1.00 | 3.08 | 340.45 |
| 01-literal/sherlock-ru | 724 | 17145.60 ± 0.5% | not timed | not timed | 17250.30 ± 0.3% | 1418.50 ± 14.4% | not timed | not timed | 17160.72 ± 0.8% | | 1.00 | 0.99 | 12.09 |
| 01-literal/sherlock-casei-ru | 746 | 6180.44 ± 0.2% | not timed | not timed | 3335.25 ± 0.1% | 30.76 ± 0.5% | not timed | not timed | 6186.90 ± 0.3% | | 1.00 | 1.85 | 200.93 |
| 01-literal/sherlock-zh | 30 | 19875.30 ± 1.0% | not timed | not timed | 18849.45 ± 1.2% | 2738.17 ± 22.1% | not timed | not timed | 19817.30 ± 0.9% | | 1.00 | 1.05 | 7.26 |
| 02-literal-alternate/sherlock-en | 714 | 6059.15 ± 0.5% | not timed | not timed | 3942.63 ± 0.3% | 16.63 ± 0.1% | not timed | not timed | 6054.43 ± 0.4% | | 1.00 | 1.54 | 364.29 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1982.77 ± 1.4% | not timed | not timed | 699.29 ± 0.2% | 11.09 ± 0.2% | not timed | not timed | 1989.83 ± 1.1% | | 1.00 | 2.84 | 178.76 |
| 02-literal-alternate/sherlock-ru | 899 | 5568.06 ± 0.2% | not timed | not timed | 3256.74 ± 0.1% | 22.63 ± 0.2% | not timed | not timed | 5575.87 ± 0.1% | | 1.00 | 1.71 | 246.00 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2056.56 ± 0.5% | not timed | not timed | 1233.53 ± 0.1% | 9.11 ± 0.2% | not timed | not timed | 2059.39 ± 0.5% | | 1.00 | 1.67 | 225.68 |
| 02-literal-alternate/sherlock-zh | 207 | 7317.84 ± 0.2% | not timed | not timed | 4169.76 ± 0.2% | 31.55 ± 0.1% | not timed | not timed | 7317.51 ± 0.3% | | 1.00 | 1.75 | 231.92 |
| 03-date/ascii | 111817 | 124.46 ± 0.9% | not timed | not timed | 96.05 ± 0.2% | 0.21 ± 6.3% | not timed | not timed | 124.49 ± 0.9% | | 1.00 | 1.30 | 585.01 |
| 04-ruff-noqa/real | 84 | 403.01 ± 0.1% | not timed | not timed | 457.14 ± 0.1% | 19.65 ± 1.4% | not timed | not timed | 403.25 ± 0.2% | | 1.00 | 0.88 | 20.51 |
| 04-ruff-noqa/tweaked | 44 | 555.76 ± 0.3% | not timed | not timed | 460.81 ± 0.1% | 369.90 ± 1.2% | not timed | not timed | 555.31 ± 0.4% | | 1.00 | 1.21 | 1.50 |
| 05-lexer-veryl/single | 124800 | 5.25 ± 3.5% | not timed | not timed | 5.07 ± 0.2% | 0.21 ± 3.9% | not timed | not timed | 5.18 ± 3.5% | | 1.01 | 1.03 | 25.47 |
| 06-cloud-flare-redos/original | 107 | 413.54 ± 1.3% | not timed | not timed | 217.41 ± 0.0% | 24.94 ± 0.2% | not timed | not timed | 415.05 ± 0.0% | | 1.00 | 1.90 | 16.58 |
| 06-cloud-flare-redos/simplified-short | 102 | 415.84 ± 0.2% | not timed | not timed | 227.35 ± 0.0% | 26.71 ± 0.1% | not timed | not timed | 409.93 ± 0.0% | | 1.01 | 1.83 | 15.57 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.67 ± 0.1% | not timed | not timed | 255.69 ± 0.0% | 28.73 ± 0.1% | not timed | not timed | 578.23 ± 0.1% | | 1.02 | 2.30 | 20.45 |
| 07-unicode-character-data/parse-line | 558784 | 240.19 ± 2.3% | not timed | not timed | 172.16 ± 1.0% | 42.93 ± 5.9% | not timed | not timed | 242.02 ± 0.2% | | 0.99 | 1.40 | 5.60 |
| 08-words/all-english | 56691 | 116.66 ± 0.3% | not timed | not timed | 83.03 ± 0.2% | 13.10 ± 12.8% | not timed | not timed | 116.65 ± 0.2% | | 1.00 | 1.41 | 8.91 |
| 08-words/long-english | 839 | 613.54 ± 0.4% | not timed | not timed | 593.88 ± 0.1% | 32.57 ± 0.2% | not timed | not timed | 613.98 ± 0.2% | | 1.00 | 1.03 | 18.84 |
| 09-aws-keys/full | 0 | 408.12 ± 0.3% | not timed | not timed | 462.95 ± 0.2% | 64.54 ± 0.1% | not timed | not timed | 408.42 ± 0.2% | | 1.00 | 0.88 | 6.32 |
| 09-aws-keys/quick | 0 | 871.30 ± 0.2% | not timed | not timed | 991.57 ± 0.6% | 423.17 ± 1.8% | not timed | not timed | 871.90 ± 0.2% | | 1.00 | 0.88 | 2.06 |
| 10-bounded-repeat/letters-en | 1833 | 584.51 ± 1.6% | not timed | not timed | 516.12 ± 0.4% | 19.50 ± 0.6% | not timed | not timed | 581.17 ± 1.7% | | 1.01 | 1.13 | 29.97 |
| 10-bounded-repeat/letters-ru | 3475 | 508.81 ± 1.7% | not timed | not timed | 478.82 ± 0.2% | 22.73 ± 9.3% | not timed | not timed | 510.68 ± 1.0% | | 1.00 | 1.06 | 22.39 |
| 10-bounded-repeat/context | 53 | 84.99 ± 2.0% | not timed | not timed | 66.33 ± 0.8% | 19.83 ± 0.3% | not timed | not timed | 85.67 ± 1.5% | | 0.99 | 1.28 | 4.29 |
| 10-bounded-repeat/capitals | 11 | 641.65 ± 7.9% | not timed | not timed | 615.80 ± 0.0% | 36.46 ± 0.1% | not timed | not timed | 640.91 ± 8.0% | | 1.00 | 1.04 | 17.60 |
| 11-unstructured-to-json/extract | 600 | 56.71 ± 0.6% | not timed | not timed | 77.50 ± 0.2% | 49.20 ± 0.4% | not timed | not timed | 56.89 ± 0.4% | | 1.00 | 0.73 | 1.15 |
| 12-dictionary/single | 1 | 567.09 ± 0.2% | not timed | not timed | 559.36 ± 0.2% | 0.41 ± 0.1% | not timed | not timed | 568.68 ± 0.2% | | 1.00 | 1.01 | 1393.21 |
| 14-quadratic/1x | 100 | 21.09 ± 1.6% | not timed | not timed | 10.02 ± 0.2% | 0.98 ± 5.7% | not timed | not timed | 21.02 ± 1.1% | | 1.00 | 2.10 | 21.55 |
| 14-quadratic/2x | 200 | 17.35 ± 1.1% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 0.6% | not timed | not timed | 17.37 ± 0.3% | | 1.00 | 3.13 | 32.52 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.3% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 2.1% | not timed | not timed | 7.70 ± 0.7% | | 1.00 | 6.34 | 66.48 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.21 ± 0.9% | not timed | not timed | 0.35 ± 1.1% | 0.55 ± 4.6% | not timed | not timed | 1.21 ± 2.2% | | 1.00 | 3.51 | 2.19 |
| 04-ruff-noqa/compile-real | 1 | 104.82 ± 1.0% | not timed | not timed | 13.84 ± 0.4% | 142.29 ± 2.0% | not timed | not timed | 104.92 ± 0.4% | | 1.00 | 7.57 | 0.74 |
| 05-lexer-veryl/compile-single | 1 | 13.98 ± 1.1% | not timed | not timed | 2.53 ± 0.7% | 6.53 ± 2.6% | not timed | not timed | 13.98 ± 1.0% | | 1.00 | 5.52 | 2.14 |
| 07-unicode-character-data/compile | 1 | 107.33 ± 0.3% | not timed | not timed | 25.92 ± 0.4% | 36.63 ± 2.2% | not timed | not timed | 107.67 ± 0.5% | | 1.00 | 4.14 | 2.93 |
| 09-aws-keys/compile-full | 1 | 52.97 ± 0.3% | not timed | not timed | 8.29 ± 0.6% | 23.55 ± 0.4% | not timed | not timed | 53.03 ± 0.2% | | 1.00 | 6.39 | 2.25 |
| 09-aws-keys/compile-quick | 1 | 183.41 ± 1.1% | not timed | not timed | 46.23 ± 0.1% | 136.94 ± 2.4% | not timed | not timed | 183.39 ± 0.3% | | 1.00 | 3.97 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 71.56 ± 1.6% | not timed | not timed | 11.12 ± 0.2% | 16.36 ± 3.8% | not timed | not timed | 71.87 ± 1.9% | | 1.00 | 6.43 | 4.37 |
| 10-bounded-repeat/compile-capitals | 1 | 84.84 ± 0.4% | not timed | not timed | 7.97 ± 0.3% | 23.92 ± 2.1% | not timed | not timed | 84.18 ± 1.0% | | 1.01 | 10.65 | 3.55 |
| 11-unstructured-to-json/compile | 1 | 169.63 ± 0.9% | not timed | not timed | 41.17 ± 0.4% | 69.82 ± 2.1% | not timed | not timed | 169.70 ± 0.3% | | 1.00 | 4.12 | 2.43 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.5% | not timed | not timed | 0.07 ± 16.1% | 0.10 ± 21.5% | not timed | not timed | 0.35 ± 2.0% | | 1.00 | 4.97 | 3.47 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.40 ± 4.5% | not timed | not timed | 6.47 ± 0.2% | 0.59 ± 22.9% | not timed | not timed | 7.53 ± 2.1% | | 0.98 | 1.14 | 12.45 |
| dictionary/search/english-10 | 690 | 1.05 ± 0.3% | not timed | not timed | 165.63 ± 0.9% | 0.00 ± 0.5% | not timed | not timed | 1.05 ± 0.5% | | 1.00 | 0.0063 | 352.20 |
| dictionary/search/english-15 | 15 | 559.46 ± 0.3% | not timed | not timed | 560.32 ± 0.1% | 0.37 ± 0.4% | not timed | not timed | 559.84 ± 0.9% | | 1.00 | 1.00 | 1506.36 |
| folly/awyer-inn-busted | 1 | 5587.49 ± 0.1% | not timed | not timed | 143.01 ± 0.2% | 43.95 ± 0.5% | not timed | not timed | 5575.95 ± 0.1% | | 1.00 | 39.07 | 127.14 |
| folly/literal-never-match-rare | 0 | 21144.33 ± 0.9% | not timed | not timed | 19939.11 ± 0.2% | 41026.36 ± 0.3% | not timed | not timed | 21151.12 ± 0.3% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12550.04 ± 1.3% | not timed | not timed | 19895.73 ± 0.3% | 2192.33 ± 0.9% | not timed | not timed | 12602.90 ± 0.8% | | 1.00 | 0.63 | 5.72 |
| folly/literal-never-match-tricksy | 1 | 3243.45 ± 0.3% | not timed | not timed | 4391.72 ± 0.7% | 3025.48 ± 3.1% | not timed | not timed | 3237.63 ± 0.3% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1304.06 ± 0.4% | not timed | not timed | 960.36 ± 0.4% | 373.77 ± 17.4% | not timed | not timed | 1309.43 ± 0.4% | | 1.00 | 1.36 | 3.49 |
| grep/long-words-ascii | 5073 | 459.00 ± 0.3% | not timed | not timed | 471.29 ± 0.1% | 46.19 ± 6.3% | not timed | not timed | 459.80 ± 0.1% | | 1.00 | 0.97 | 9.94 |
| imported/leipzig/twain | 811 | 20725.07 ± 1.2% | not timed | not timed | 19643.01 ± 0.2% | 11963.63 ± 9.4% | not timed | not timed | 20805.22 ± 0.5% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9060.06 ± 0.4% | not timed | not timed | 4254.84 ± 0.4% | 37.78 ± 0.1% | not timed | not timed | 9061.35 ± 1.1% | | 1.00 | 2.13 | 239.81 |
| imported/leipzig/shing | 1540 | 629.71 ± 0.2% | not timed | not timed | 13222.23 ± 2.1% | 34.09 ± 0.1% | not timed | not timed | 631.90 ± 0.1% | | 1.00 | 0.0476 | 18.47 |
| imported/leipzig/huck-saw | 262 | 8258.65 ± 3.1% | not timed | not timed | 5607.60 ± 0.3% | 31.77 ± 0.1% | not timed | not timed | 8473.55 ± 3.0% | | 0.97 | 1.47 | 259.94 |
| imported/leipzig/word-ending-nn | 262 | 609.16 ± 0.4% | not timed | not timed | 616.24 ± 0.2% | 24.61 ± 0.9% | not timed | not timed | 611.03 ± 0.1% | | 1.00 | 0.99 | 24.75 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11054.81 ± 1.0% | not timed | not timed | 4546.84 ± 0.5% | 11.52 ± 1.2% | not timed | not timed | 11115.04 ± 1.7% | | 0.99 | 2.43 | 959.81 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7807.48 ± 1.8% | not timed | not timed | 5493.23 ± 0.1% | 16.90 ± 0.1% | not timed | not timed | 7931.89 ± 2.7% | | 0.98 | 1.42 | 462.10 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4196.44 ± 0.8% | not timed | not timed | 413.75 ± 2.7% | 11.09 ± 0.1% | not timed | not timed | 4216.68 ± 0.9% | | 1.00 | 10.14 | 378.30 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 609.70 ± 0.2% | not timed | not timed | 615.40 ± 0.1% | 11.13 ± 0.1% | not timed | not timed | 610.06 ± 0.3% | | 1.00 | 0.99 | 54.78 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.58 ± 0.1% | not timed | not timed | 616.00 ± 0.1% | 9.74 ± 0.1% | not timed | not timed | 610.14 ± 0.4% | | 1.00 | 0.99 | 62.55 |
| imported/leipzig/tom-river | 2 | 6535.53 ± 1.9% | not timed | not timed | 5155.59 ± 0.1% | 30.96 ± 0.1% | not timed | not timed | 6624.01 ± 1.8% | | 0.99 | 1.27 | 211.08 |
| imported/leipzig/ing | 78424 | 608.82 ± 0.7% | not timed | not timed | 571.12 ± 0.2% | 28.30 ± 3.0% | not timed | not timed | 607.41 ± 0.7% | | 1.00 | 1.07 | 21.52 |
| imported/leipzig/ing-whitespace | 55248 | 758.47 ± 1.0% | not timed | not timed | 2082.39 ± 0.3% | 20.54 ± 2.9% | not timed | not timed | 759.45 ± 1.0% | | 1.00 | 0.36 | 36.92 |
| imported/leipzig/awyer-inn | 209 | 774.58 ± 1.5% | not timed | not timed | 4273.24 ± 0.5% | 22.69 ± 0.0% | not timed | not timed | 775.12 ± 1.4% | | 1.00 | 0.18 | 34.13 |
| imported/leipzig/quotes-bounded | 8886 | 2127.76 ± 0.3% | not timed | not timed | 3014.75 ± 0.4% | 38.25 ± 0.1% | not timed | not timed | 2123.41 ± 0.4% | | 1.00 | 0.71 | 55.63 |
| imported/leipzig/non-ascii-alternate | 2 | 12751.29 ± 3.3% | not timed | not timed | 5673.80 ± 0.1% | 51.07 ± 0.1% | not timed | not timed | 13101.71 ± 2.6% | | 0.97 | 2.25 | 249.67 |
| imported/leipzig/math-symbols | 69 | 1972.06 ± 1.0% | not timed | not timed | 619.25 ± 0.1% | 36.46 ± 0.8% | not timed | not timed | 1968.97 ± 1.0% | | 1.00 | 3.18 | 54.08 |
| imported/leipzig/bounded-strings-ending-z | 0 | 594.46 ± 0.3% | not timed | not timed | 617.94 ± 0.1% | 22.52 ± 0.2% | not timed | not timed | 592.51 ± 0.3% | | 1.00 | 0.96 | 26.40 |
| imported/lh3lh3-reb/uri | 17549 | 631.84 ± 0.1% | not timed | not timed | 1067.16 ± 0.2% | 27.90 ± 2.2% | not timed | not timed | 633.10 ± 0.1% | | 1.00 | 0.59 | 22.65 |
| imported/lh3lh3-reb/email | 15057 | 666.89 ± 0.1% | not timed | not timed | 1167.28 ± 0.1% | 31.01 ± 2.5% | not timed | not timed | 668.29 ± 0.1% | | 1.00 | 0.57 | 21.51 |
| imported/lh3lh3-reb/date | 668 | 864.82 ± 0.2% | not timed | not timed | 1045.34 ± 0.3% | 51.55 ± 3.9% | not timed | not timed | 864.07 ± 0.2% | | 1.00 | 0.83 | 16.77 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 641.25 ± 0.2% | not timed | not timed | 419.10 ± 0.2% | 15.81 ± 1.3% | not timed | not timed | 642.54 ± 0.1% | | 1.00 | 1.53 | 40.57 |
| imported/mariomka/email | 92 | 705.57 ± 0.2% | not timed | not timed | 29697.68 ± 1.0% | 32.86 ± 0.1% | not timed | not timed | 706.69 ± 0.1% | | 1.00 | 0.0238 | 21.47 |
| imported/mariomka/uri | 5301 | 608.84 ± 0.2% | not timed | not timed | 6094.17 ± 0.2% | 32.57 ± 0.5% | not timed | not timed | 605.93 ± 0.1% | | 1.00 | 0.0999 | 18.69 |
| imported/mariomka/ip | 5 | 2157.21 ± 2.2% | not timed | not timed | 2971.42 ± 0.2% | 21.04 ± 0.3% | not timed | not timed | 2154.49 ± 2.2% | | 1.00 | 0.73 | 102.52 |
| imported/rsc/no-exponential | 0 | 562.73 ± 0.1% | not timed | not timed | 321.84 ± 0.1% | 23.86 ± 0.3% | not timed | not timed | 563.21 ± 0.5% | | 1.00 | 1.75 | 23.59 |
| imported/rsc/literal | 1 | 745.72 ± 1.0% | not timed | not timed | 1650.86 ± 7.7% | 191.17 ± 22.0% | not timed | not timed | 743.86 ± 3.9% | | 1.00 | 0.45 | 3.90 |
| imported/rsc/not-literal | 2 | 708.29 ± 1.7% | not timed | not timed | 731.41 ± 0.4% | 45.82 ± 7.8% | not timed | not timed | 706.93 ± 2.1% | | 1.00 | 0.97 | 15.46 |
| imported/rsc/match-class | 1 | 1310.12 ± 2.7% | not timed | not timed | 1628.28 ± 0.2% | 58.63 ± 14.2% | not timed | not timed | 1303.54 ± 0.2% | | 1.01 | 0.80 | 22.35 |
| imported/rsc/match-class-in-range | 1 | 1308.38 ± 2.1% | not timed | not timed | 2344.36 ± 7.4% | 59.71 ± 6.9% | not timed | not timed | 1312.43 ± 0.2% | | 1.00 | 0.56 | 21.91 |
| imported/rsc/match-class-unicode | 1 | 525.42 ± 0.1% | not timed | not timed | 516.12 ± 0.0% | 72.78 ± 0.3% | not timed | not timed | 524.61 ± 0.1% | | 1.00 | 1.02 | 7.22 |
| imported/rsc/anchored-literal-short-non-match | 0 | 533.99 ± 0.3% | not timed | not timed | 958.92 ± 0.1% | 227.40 ± 0.6% | not timed | not timed | 533.80 ± 0.4% | | 1.00 | 0.56 | 2.35 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7960.74 ± 0.1% | not timed | not timed | 14381.26 ± 0.2% | 3406.58 ± 0.5% | not timed | not timed | 7975.20 ± 0.1% | | 1.00 | 0.55 | 2.34 |
| imported/rsc/anchored-literal-short-match | 4 | 419.43 ± 1.8% | not timed | not timed | 481.63 ± 0.2% | 83.31 ± 9.2% | not timed | not timed | 420.43 ± 0.5% | | 1.00 | 0.87 | 5.03 |
| imported/rsc/anchored-literal-long-match | 4 | 3004.91 ± 0.8% | not timed | not timed | 7251.40 ± 0.1% | 1232.24 ± 2.6% | not timed | not timed | 3022.99 ± 0.8% | | 0.99 | 0.41 | 2.44 |
| imported/rsc/one-pass-short | 17 | 312.22 ± 7.9% | not timed | not timed | 216.20 ± 0.2% | 30.96 ± 15.3% | not timed | not timed | 311.46 ± 2.7% | | 1.00 | 1.44 | 10.08 |
| imported/rsc/one-pass-short-not | 17 | 219.05 ± 6.5% | not timed | not timed | 226.67 ± 0.1% | 31.68 ± 13.2% | not timed | not timed | 218.78 ± 1.6% | | 1.00 | 0.97 | 6.91 |
| imported/rsc/one-pass-long-prefix | 26 | 237.68 ± 9.6% | not timed | not timed | 284.75 ± 1.5% | 98.49 ± 14.9% | not timed | not timed | 240.29 ± 2.0% | | 0.99 | 0.83 | 2.41 |
| imported/rsc/one-pass-long-prefix-not | 26 | 315.05 ± 6.3% | not timed | not timed | 283.06 ± 0.3% | 69.21 ± 19.9% | not timed | not timed | 311.94 ± 1.8% | | 1.01 | 1.11 | 4.55 |
| imported/rsc/long-needle1 | 31 | 21940.43 ± 0.1% | not timed | not timed | 20161.33 ± 0.3% | 3.76 ± 0.1% | not timed | not timed | 21934.52 ± 0.2% | | 1.00 | 1.09 | 5833.02 |
| imported/rsc/long-needle2 | 31 | 22097.84 ± 0.2% | not timed | not timed | 216.34 ± 0.1% | 3.76 ± 0.1% | not timed | not timed | 22106.40 ± 0.0% | | 1.00 | 102.14 | 5883.23 |
| imported/rsc/easy0-32 | 26 | 1063.72 ± 2.9% | not timed | not timed | 1633.27 ± 4.1% | 147.93 ± 18.5% | not timed | not timed | 1057.55 ± 2.9% | | 1.01 | 0.65 | 7.19 |
| imported/rsc/easy0-1k | 26 | 14952.82 ± 0.3% | not timed | not timed | 12446.00 ± 1.5% | 2307.88 ± 16.2% | not timed | not timed | 14965.40 ± 2.3% | | 1.00 | 1.20 | 6.48 |
| imported/rsc/easy0-32k | 26 | 22898.23 ± 0.1% | not timed | not timed | 20400.77 ± 0.2% | 18798.23 ± 20.4% | not timed | not timed | 22902.69 ± 2.9% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21753.49 ± 3.3% | not timed | not timed | 19850.64 ± 0.7% | 37336.17 ± 5.2% | not timed | not timed | 21733.12 ± 1.3% | | 1.00 | 1.10 | 0.58 |
| imported/rsc/easy1-32 | 19 | 354.35 ± 1.9% | not timed | not timed | 639.41 ± 0.1% | 130.78 ± 15.5% | not timed | not timed | 360.87 ± 0.2% | | 0.98 | 0.55 | 2.71 |
| imported/rsc/easy1-1k | 19 | 583.93 ± 2.4% | not timed | not timed | 13009.03 ± 0.2% | 2498.59 ± 17.6% | not timed | not timed | 581.75 ± 0.5% | | 1.00 | 0.0449 | 0.23 |
| imported/rsc/easy1-32k | 19 | 603.04 ± 0.3% | not timed | not timed | 406065.48 ± 0.2% | 20536.27 ± 20.7% | not timed | not timed | 601.31 ± 3.1% | | 1.00 | 0.0015 | 0.0294 |
| imported/rsc/easy1-1mb | 19 | 601.38 ± 0.6% | not timed | not timed | 12990023.86 ± 0.1% | 34829.53 ± 4.6% | not timed | not timed | 599.95 ± 0.8% | | 1.00 | 0.0000 | 0.0173 |
| imported/rsc/medium-32 | 27 | 424.21 ± 0.6% | not timed | not timed | 652.09 ± 0.4% | 69.96 ± 14.8% | not timed | not timed | 425.09 ± 0.4% | | 1.00 | 0.65 | 6.06 |
| imported/rsc/medium-1k | 27 | 6765.83 ± 0.1% | not timed | not timed | 11349.40 ± 0.3% | 72.46 ± 0.2% | not timed | not timed | 6770.29 ± 0.3% | | 1.00 | 0.60 | 93.37 |
| imported/rsc/medium-32k | 27 | 21631.05 ± 0.2% | not timed | not timed | 352920.15 ± 0.2% | 48.81 ± 0.2% | not timed | not timed | 21578.68 ± 0.0% | | 1.00 | 0.0613 | 443.17 |
| imported/rsc/medium-1mb | 27 | 21262.82 ± 3.9% | not timed | not timed | 11264620.32 ± 0.2% | 48.77 ± 0.1% | not timed | not timed | 21392.81 ± 1.3% | | 0.99 | 0.0019 | 435.97 |
| imported/rsc/hard-32 | 58 | 254.79 ± 2.4% | not timed | not timed | 364.96 ± 0.1% | 49.81 ± 8.7% | not timed | not timed | 256.40 ± 0.1% | | 0.99 | 0.70 | 5.12 |
| imported/rsc/hard-1k | 27 | 577.12 ± 0.4% | not timed | not timed | 11570.06 ± 0.3% | 40.76 ± 0.1% | not timed | not timed | 577.48 ± 0.3% | | 1.00 | 0.0499 | 14.16 |
| imported/rsc/hard-32k | 27 | 600.76 ± 0.6% | not timed | not timed | 364989.52 ± 0.8% | 29.35 ± 0.1% | not timed | not timed | 598.03 ± 0.4% | | 1.00 | 0.0016 | 20.47 |
| imported/rsc/hard-1mb | 51 | 603.67 ± 0.8% | not timed | not timed | 7262570.91 ± 0.1% | 29.40 ± 0.1% | not timed | not timed | 598.46 ± 0.8% | | 1.01 | 0.0001 | 20.53 |
| imported/rsc/reallyhard0-32 | 58 | 254.40 ± 2.3% | not timed | not timed | 222.25 ± 0.1% | 49.76 ± 8.4% | not timed | not timed | 254.56 ± 0.1% | | 1.00 | 1.14 | 5.11 |
| imported/rsc/reallyhard0-1k | 27 | 574.96 ± 0.2% | not timed | not timed | 585.21 ± 0.2% | 40.75 ± 0.1% | not timed | not timed | 579.79 ± 0.3% | | 0.99 | 0.98 | 14.11 |
| imported/rsc/reallyhard0-32k | 27 | 600.97 ± 0.5% | not timed | not timed | 616.14 ± 0.1% | 29.35 ± 0.0% | not timed | not timed | 603.23 ± 0.6% | | 1.00 | 0.98 | 20.48 |
| imported/rsc/reallyhard0-1mb | 51 | 594.22 ± 0.3% | not timed | not timed | 617.94 ± 0.2% | 29.09 ± 0.3% | not timed | not timed | 593.55 ± 1.5% | | 1.00 | 0.96 | 20.43 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.10 ± 1.6% | not timed | not timed | 197.57 ± 0.1% | 61.36 ± 14.8% | not timed | not timed | 274.36 ± 0.1% | | 1.00 | 1.39 | 4.47 |
| imported/rsc/reallyreallyhard0-1k | 16 | 856.69 ± 1.5% | not timed | not timed | 5957.78 ± 0.1% | 34.26 ± 0.9% | not timed | not timed | 855.20 ± 1.0% | | 1.00 | 0.14 | 25.00 |
| imported/rsc/reallyreallyhard0-32k | 16 | 622.47 ± 4.0% | not timed | not timed | 19259.50 ± 0.1% | 24.65 ± 4.6% | not timed | not timed | 619.84 ± 1.6% | | 1.00 | 0.0323 | 25.25 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 592.14 ± 0.2% | not timed | not timed | 19886.15 ± 1.8% | 24.66 ± 1.8% | not timed | not timed | 585.12 ± 1.1% | | 1.01 | 0.0298 | 24.01 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 268.94 ± 2.9% | not timed | not timed | 212.41 ± 0.2% | 60.22 ± 11.4% | not timed | not timed | 268.75 ± 0.2% | | 1.00 | 1.27 | 4.47 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 839.58 ± 1.4% | not timed | not timed | 6195.71 ± 0.2% | 33.97 ± 0.3% | not timed | not timed | 847.87 ± 0.8% | | 0.99 | 0.14 | 24.71 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 619.47 ± 4.1% | not timed | not timed | 19236.75 ± 0.1% | 24.62 ± 1.3% | not timed | not timed | 624.44 ± 5.4% | | 0.99 | 0.0322 | 25.16 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 588.40 ± 0.2% | not timed | not timed | 19902.33 ± 1.4% | 24.84 ± 1.1% | not timed | not timed | 593.74 ± 0.7% | | 0.99 | 0.0296 | 23.68 |
| imported/sherlock/name-sherlock | 776 | 19739.62 ± 1.5% | not timed | not timed | 18541.02 ± 0.9% | 10220.18 ± 29.0% | not timed | not timed | 19734.66 ± 1.8% | | 1.00 | 1.06 | 1.93 |
| imported/sherlock/name-holmes | 2766 | 15152.67 ± 1.8% | not timed | not timed | 15523.32 ± 0.5% | 3129.40 ± 14.8% | not timed | not timed | 15329.72 ± 1.8% | | 0.99 | 0.98 | 4.84 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19849.10 ± 1.8% | not timed | not timed | 18577.18 ± 0.3% | 8095.54 ± 18.8% | not timed | not timed | 19848.22 ± 2.0% | | 1.00 | 1.07 | 2.45 |
| imported/sherlock/name-sherlock-casei | 816 | 15714.39 ± 0.4% | not timed | not timed | 4016.10 ± 0.1% | 32.36 ± 1.0% | not timed | not timed | 15686.93 ± 0.4% | | 1.00 | 3.91 | 485.62 |
| imported/sherlock/name-holmes-casei | 2802 | 9416.46 ± 7.5% | not timed | not timed | 3315.97 ± 0.2% | 37.70 ± 0.2% | not timed | not timed | 9441.61 ± 5.4% | | 1.00 | 2.84 | 249.78 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13055.90 ± 2.5% | not timed | not timed | 3950.07 ± 0.3% | 32.59 ± 0.3% | not timed | not timed | 13067.70 ± 1.5% | | 1.00 | 3.31 | 400.61 |
| imported/sherlock/name-whitespace | 1461 | 15121.16 ± 7.5% | not timed | not timed | 14531.48 ± 0.3% | 7351.10 ± 44.2% | not timed | not timed | 15126.74 ± 1.6% | | 1.00 | 1.04 | 2.06 |
| imported/sherlock/name-alt1 | 1142 | 11476.72 ± 0.7% | not timed | not timed | 16377.71 ± 0.7% | 4142.69 ± 16.5% | not timed | not timed | 11491.81 ± 2.6% | | 1.00 | 0.70 | 2.77 |
| imported/sherlock/name-alt2 | 3542 | 8631.37 ± 0.4% | not timed | not timed | 3825.81 ± 0.1% | 31.38 ± 0.2% | not timed | not timed | 8643.99 ± 0.2% | | 1.00 | 2.26 | 275.09 |
| imported/sherlock/name-alt3 | 4507 | 5450.66 ± 0.4% | not timed | not timed | 3625.76 ± 0.0% | 9.81 ± 3.3% | not timed | not timed | 5459.32 ± 0.2% | | 1.00 | 1.50 | 555.90 |
| imported/sherlock/name-alt3-casei | 4593 | 1517.17 ± 2.0% | not timed | not timed | 285.76 ± 0.3% | 6.47 ± 0.2% | not timed | not timed | 1518.47 ± 1.2% | | 1.00 | 5.31 | 234.46 |
| imported/sherlock/name-alt4 | 3686 | 6183.17 ± 0.2% | not timed | not timed | 3795.65 ± 0.1% | 31.36 ± 0.4% | not timed | not timed | 6202.72 ± 0.2% | | 1.00 | 1.63 | 197.17 |
| imported/sherlock/name-alt4-casei | 4254 | 2765.46 ± 1.6% | not timed | not timed | 2592.80 ± 0.1% | 19.90 ± 0.3% | not timed | not timed | 2774.79 ± 1.2% | | 1.00 | 1.07 | 138.99 |
| imported/sherlock/name-alt5 | 4028 | 6238.37 ± 0.2% | not timed | not timed | 3747.72 ± 0.1% | 21.76 ± 0.1% | not timed | not timed | 6243.96 ± 0.3% | | 1.00 | 1.66 | 286.72 |
| imported/sherlock/name-alt5-casei | 4104 | 3460.99 ± 2.2% | not timed | not timed | 2222.82 ± 0.4% | 14.36 ± 0.1% | not timed | not timed | 3469.33 ± 0.9% | | 1.00 | 1.56 | 241.04 |
| imported/sherlock/no-match-uncommon | 0 | 21518.98 ± 0.3% | not timed | not timed | 19555.84 ± 0.4% | 35458.26 ± 1.0% | not timed | not timed | 21488.59 ± 0.9% | | 1.00 | 1.10 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21290.76 ± 0.7% | not timed | not timed | 19457.40 ± 0.5% | 1278.30 ± 0.7% | not timed | not timed | 21395.96 ± 0.4% | | 1.00 | 1.09 | 16.66 |
| imported/sherlock/no-match-really-common | 0 | 16193.83 ± 2.5% | not timed | not timed | 18723.76 ± 0.8% | 1276.48 ± 1.1% | not timed | not timed | 16362.40 ± 1.3% | | 0.99 | 0.86 | 12.69 |
| imported/sherlock/the-lower | 21654 | 2324.19 ± 0.9% | not timed | not timed | 2324.18 ± 0.3% | 243.54 ± 15.6% | not timed | not timed | 2330.32 ± 1.4% | | 1.00 | 1.00 | 9.54 |
| imported/sherlock/the-upper | 2223 | 12721.73 ± 10.2% | not timed | not timed | 13623.05 ± 0.8% | 2613.77 ± 22.4% | not timed | not timed | 12806.55 ± 1.1% | | 0.99 | 0.93 | 4.87 |
| imported/sherlock/the-casei | 23961 | 2018.57 ± 1.3% | not timed | not timed | 1314.83 ± 0.3% | 34.71 ± 33.1% | not timed | not timed | 2018.44 ± 0.3% | | 1.00 | 1.54 | 58.15 |
| imported/sherlock/everything-greedy | 581881 | 271.15 ± 1.0% | not timed | not timed | 164.98 ± 0.2% | 28.81 ± 33.2% | not timed | not timed | 271.56 ± 0.3% | | 1.00 | 1.64 | 9.41 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.54 ± 0.2% | not timed | not timed | 212.77 ± 0.8% | 32.91 ± 0.1% | not timed | not timed | 463.65 ± 0.9% | | 1.00 | 2.17 | 14.06 |
| imported/sherlock/letters | 447175 | 54.49 ± 6.8% | not timed | not timed | 33.16 ± 0.2% | 5.25 ± 19.8% | not timed | not timed | 54.38 ± 1.4% | | 1.00 | 1.64 | 10.38 |
| imported/sherlock/letters-upper | 14180 | 434.11 ± 3.6% | not timed | not timed | 368.83 ± 0.2% | 29.69 ± 25.9% | not timed | not timed | 435.00 ± 0.2% | | 1.00 | 1.18 | 14.62 |
| imported/sherlock/letters-lower | 432995 | 55.33 ± 1.6% | not timed | not timed | 34.05 ± 0.1% | 5.74 ± 0.9% | not timed | not timed | 55.34 ± 0.3% | | 1.00 | 1.62 | 9.64 |
| imported/sherlock/words | 447639 | 106.72 ± 1.4% | not timed | not timed | 83.16 ± 0.1% | 14.18 ± 5.3% | not timed | not timed | 107.09 ± 0.6% | | 1.00 | 1.28 | 7.53 |
| imported/sherlock/before-holmes | 4073 | 598.45 ± 0.3% | not timed | not timed | 8474.86 ± 0.1% | 24.09 ± 1.1% | not timed | not timed | 597.65 ± 0.4% | | 1.00 | 0.0706 | 24.85 |
| imported/sherlock/before-after-holmes | 2593 | 597.28 ± 0.4% | not timed | not timed | 9468.60 ± 0.5% | 23.89 ± 1.5% | not timed | not timed | 597.91 ± 0.4% | | 1.00 | 0.0631 | 25.00 |
| imported/sherlock/holmes-cochar-watson | 150 | 5233.50 ± 0.3% | not timed | not timed | 3430.51 ± 0.1% | 31.05 ± 0.1% | not timed | not timed | 5239.79 ± 0.4% | | 1.00 | 1.53 | 168.57 |
| imported/sherlock/holmes-coword-watson | 14309 | 1263.12 ± 2.6% | not timed | not timed | 1120.60 ± 0.2% | 6.79 ± 0.3% | not timed | not timed | 1262.84 ± 2.8% | | 1.00 | 1.13 | 186.04 |
| imported/sherlock/quotes | 14437 | 1415.94 ± 0.5% | not timed | not timed | 1760.47 ± 0.8% | 35.14 ± 0.3% | not timed | not timed | 1403.33 ± 0.1% | | 1.01 | 0.80 | 40.29 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 602.43 ± 0.7% | not timed | not timed | 15989.85 ± 0.5% | 36.88 ± 0.5% | not timed | not timed | 602.05 ± 1.1% | | 1.00 | 0.0377 | 16.33 |
| imported/sherlock/word-ending-n | 35297 | 468.04 ± 3.4% | not timed | not timed | 410.58 ± 0.1% | 23.58 ± 18.3% | not timed | not timed | 467.03 ± 0.4% | | 1.00 | 1.14 | 19.85 |
| imported/sherlock/repeated-class-negation | 2130 | 14569.79 ± 0.7% | not timed | not timed | 10934.37 ± 0.5% | 11.58 ± 0.3% | not timed | not timed | 14549.91 ± 0.8% | | 1.00 | 1.33 | 1258.23 |
| imported/sherlock/ing-suffix | 20547 | 555.41 ± 0.3% | not timed | not timed | 518.05 ± 0.1% | 28.90 ± 0.1% | not timed | not timed | 554.45 ± 0.3% | | 1.00 | 1.07 | 19.22 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 595.25 ± 0.2% | not timed | not timed | 2101.31 ± 0.1% | 20.58 ± 0.1% | not timed | not timed | 594.25 ± 0.3% | | 1.00 | 0.28 | 28.92 |
| opt/accelerate/whole-line | 239963 | 458.10 ± 0.2% | not timed | not timed | 372.29 ± 0.5% | 92.12 ± 17.3% | not timed | not timed | 458.56 ± 0.3% | | 1.00 | 1.23 | 4.97 |
| opt/accelerate/non-dna | 16745 | 413.81 ± 2.3% | not timed | not timed | 398.52 ± 0.1% | 29.48 ± 21.5% | not timed | not timed | 412.11 ± 0.3% | | 1.00 | 1.04 | 14.04 |
| opt/backtrack/words-english | 40536 | 137.10 ± 1.9% | not timed | not timed | 94.63 ± 0.4% | 19.80 ± 7.4% | not timed | not timed | 137.13 ± 2.3% | | 1.00 | 1.45 | 6.92 |
| opt/fixed-length/too-small-ascii | 0 | 311.51 ± 0.7% | not timed | not timed | 708.02 ± 1.0% | 79.66 ± 1.1% | not timed | not timed | 316.00 ± 0.3% | | 0.99 | 0.44 | 3.91 |
| opt/fixed-length/too-big-ascii | 0 | 643.93 ± 0.7% | not timed | not timed | 5800.89 ± 0.9% | 126.05 ± 0.3% | not timed | not timed | 649.44 ± 0.9% | | 0.99 | 0.11 | 5.11 |
| opt/fixed-length/go33484-1 | 0 | 45.40 ± 0.2% | not timed | not timed | 1102357.12 ± 1.1% | 61306.82 ± 0.5% | not timed | not timed | 45.42 ± 0.3% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5530.84 ± 0.1% | not timed | not timed | 1113411.83 ± 0.9% | 32152.81 ± 1.0% | not timed | not timed | 5522.85 ± 0.1% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1784.33 ± 2.9% | not timed | not timed | 110553.26 ± 0.8% | 756.44 ± 0.3% | not timed | not timed | 1762.53 ± 1.5% | | 1.01 | 0.0161 | 2.36 |
| opt/literal-alt/one-pattern | 1 | 554.28 ± 0.0% | not timed | not timed | 542.57 ± 0.2% | 0.40 ± 0.2% | not timed | not timed | 555.52 ± 0.1% | | 1.00 | 1.02 | 1380.04 |
| opt/onepass/fn-predicate | 916 | 367.85 ± 1.0% | not timed | not timed | 333.25 ± 0.2% | 202.51 ± 13.3% | not timed | not timed | 371.01 ± 0.2% | | 0.99 | 1.10 | 1.82 |
| opt/onepass/first-three-words-english | 35128 | 148.27 ± 7.7% | not timed | not timed | 201.60 ± 0.1% | 80.39 ± 12.0% | not timed | not timed | 149.83 ± 0.9% | | 0.99 | 0.74 | 1.84 |
| opt/prefilter/literal-english | 1 | 20517.66 ± 0.5% | not timed | not timed | 19687.80 ± 0.3% | 17548.96 ± 0.6% | not timed | not timed | 20515.19 ± 0.5% | | 1.00 | 1.04 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14454.71 ± 0.6% | not timed | not timed | 4317.65 ± 0.1% | 32.33 ± 0.0% | not timed | not timed | 14455.75 ± 0.3% | | 1.00 | 3.35 | 447.08 |
| opt/prefilter/literal-russian | 1 | 21029.66 ± 0.7% | not timed | not timed | 19517.26 ± 0.8% | 3323.05 ± 0.3% | not timed | not timed | 21070.32 ± 0.9% | | 1.00 | 1.08 | 6.33 |
| opt/prefilter/literal-casei-russian | 1 | 8551.51 ± 0.2% | not timed | not timed | 3890.83 ± 0.1% | 30.90 ± 0.3% | not timed | not timed | 8555.33 ± 0.3% | | 1.00 | 2.20 | 276.75 |
| opt/prefilter/rust-functions | 948 | 6831.74 ± 0.4% | not timed | not timed | 8996.14 ± 0.3% | 1875.11 ± 0.4% | not timed | not timed | 6831.99 ± 0.2% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 5578.98 ± 0.3% | not timed | not timed | 21654160.18 ± 0.2% | 50.25 ± 0.1% | not timed | not timed | 5590.58 ± 0.3% | | 1.00 | 0.0003 | 111.03 |
| opt/reverse-inner/holmes | 2593 | 597.05 ± 0.4% | not timed | not timed | 9485.32 ± 0.4% | 24.13 ± 1.1% | not timed | not timed | 597.66 ± 0.4% | | 1.00 | 0.0629 | 24.74 |
| opt/reverse-inner/email | 47 | 1045.92 ± 0.1% | not timed | not timed | 45015.36 ± 0.5% | 32.40 ± 0.3% | not timed | not timed | 1044.90 ± 0.1% | | 1.00 | 0.0232 | 32.28 |
| opt/reverse-inner/factored-prefix | 3542 | 591.79 ± 0.7% | not timed | not timed | 595.55 ± 0.1% | 12.56 ± 0.2% | not timed | not timed | 591.43 ± 0.6% | | 1.00 | 0.99 | 47.13 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5511.95 ± 0.1% | not timed | not timed | 613.23 ± 0.3% | 75.13 ± 0.3% | not timed | not timed | 5519.67 ± 0.2% | | 1.00 | 8.99 | 73.36 |
| opt/reverse-inner/no-quadratic-forward | 0 | 688.06 ± 2.5% | not timed | not timed | 288.27 ± 0.3% | 24.82 ± 0.3% | not timed | not timed | 684.74 ± 11.7% | | 1.00 | 2.39 | 27.73 |
| opt/reverse-suffix/holmes | 4073 | 599.65 ± 0.2% | not timed | not timed | 8470.02 ± 0.1% | 24.01 ± 1.3% | not timed | not timed | 596.72 ± 0.3% | | 1.00 | 0.0708 | 24.97 |
| opt/reverse-suffix/no-quadratic | 0 | 5521.81 ± 0.1% | not timed | not timed | 616.39 ± 0.6% | 75.19 ± 0.1% | not timed | not timed | 5504.03 ± 0.1% | | 1.00 | 8.96 | 73.44 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.96 ± 0.3% | not timed | not timed | 131.93 ± 0.5% | 12.89 ± 16.9% | not timed | not timed | 121.06 ± 2.1% | | 1.00 | 0.92 | 9.38 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.17 ± 3.3% | not timed | not timed | 131.79 ± 0.6% | 13.00 ± 13.7% | not timed | not timed | 119.81 ± 2.3% | | 1.00 | 0.91 | 9.25 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.1% | not timed | not timed | 0.55 ± 0.2% | 112.59 ± 1.0% | not timed | not timed | 0.28 ± 0.2% | | 1.00 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.06 ± 0.3% | not timed | not timed | 293.95 ± 0.2% | 99.79 ± 0.9% | not timed | not timed | 308.62 ± 0.5% | | 1.02 | 1.08 | 3.17 |
| reported/i13-subset-regex/original-ascii | 4094 | 11059.20 ± 0.5% | not timed | not timed | 4543.89 ± 0.3% | 11.51 ± 0.1% | not timed | not timed | 11112.99 ± 1.0% | | 1.00 | 2.43 | 960.50 |
| reported/i13-subset-regex/original-unicode | 4094 | 10930.21 ± 2.7% | not timed | not timed | 252.37 ± 2.9% | 11.53 ± 1.4% | not timed | not timed | 11108.35 ± 0.7% | | 0.98 | 43.31 | 948.28 |
| reported/i13-subset-regex/big-ascii | 1955 | 10627.72 ± 1.2% | not timed | not timed | 68.16 ± 3.5% | 9.86 ± 0.0% | not timed | not timed | 10679.03 ± 1.2% | | 1.00 | 155.93 | 1077.35 |
| reported/i13-subset-regex/big-unicode | 1955 | 10598.51 ± 1.2% | not timed | not timed | 12.29 ± 54.9% | 9.86 ± 0.0% | not timed | not timed | 10720.16 ± 1.2% | | 0.99 | 862.72 | 1074.42 |
| reported/i13-subset-regex/huge-ascii | 55 | 10126.99 ± 1.3% | not timed | not timed | 11.01 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 9717.46 ± 3.2% | | 1.04 | 919.72 | 1154.75 |
| reported/i13-subset-regex/huge-unicode | 55 | 10091.72 ± 1.3% | not timed | not timed | 10.98 ± 0.3% | 8.77 ± 0.1% | not timed | not timed | 9902.89 ± 2.9% | | 1.02 | 919.34 | 1150.73 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.01 ± 0.1% | 8.77 ± 1.1% | not timed | not timed | 3.54 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.1% | not timed | not timed | 10.98 ± 0.3% | 8.77 ± 0.3% | not timed | not timed | 5.02 ± 0.1% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 467.94 ± 0.3% | not timed | not timed | 104.78 ± 0.2% | 6.56 ± 0.3% | not timed | not timed | 469.36 ± 0.4% | | 1.00 | 4.47 | 71.38 |
| reported/i787-keywords/opt-ascii | 5674 | 464.62 ± 0.4% | not timed | not timed | 277.01 ± 0.1% | 10.30 ± 0.3% | not timed | not timed | 470.86 ± 0.2% | | 0.99 | 1.68 | 45.12 |
| slow/quadratic-regex-1x | 100 | 6.96 ± 0.3% | not timed | not timed | 4.95 ± 0.4% | 0.05 ± 0.2% | not timed | not timed | 6.88 ± 0.4% | | 1.01 | 1.41 | 141.10 |
| slow/quadratic-regex-2x | 199 | 3.41 ± 1.4% | not timed | not timed | 2.76 ± 0.1% | 0.01 ± 10.7% | not timed | not timed | 3.40 ± 0.2% | | 1.00 | 1.23 | 266.61 |
| slow/quadratic-haystack-1x | 100 | 20.83 ± 4.1% | not timed | not timed | 10.02 ± 0.2% | 1.02 ± 7.2% | not timed | not timed | 20.77 ± 6.4% | | 1.00 | 2.08 | 20.46 |
| slow/quadratic-haystack-2x | 200 | 17.47 ± 13.0% | not timed | not timed | 5.52 ± 0.2% | 0.55 ± 0.5% | not timed | not timed | 17.45 ± 0.6% | | 1.00 | 3.17 | 31.95 |
| unicode/codepoints/any-one | 1112064 | 285.42 ± 0.8% | not timed | not timed | 176.83 ± 0.0% | 17.26 ± 21.5% | not timed | not timed | 287.46 ± 0.3% | | 0.99 | 1.61 | 16.54 |
| unicode/codepoints/any-all | 4382592 | 289.18 ± 0.6% | not timed | not timed | 246.45 ± 0.2% | 110.08 ± 0.2% | not timed | not timed | 289.34 ± 0.4% | | 1.00 | 1.17 | 2.63 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.75 ± 0.4% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 611.10 ± 0.4% | not timed | not timed | 616.59 ± 0.4% | 135.48 ± 0.1% | not timed | not timed | 610.37 ± 0.5% | | 1.00 | 0.99 | 4.51 |
| unicode/overlapping-words/ascii | 6156 | 31.72 ± 0.6% | not timed | not timed | 38.90 ± 0.2% | 3.93 ± 0.4% | not timed | not timed | 31.81 ± 0.4% | | 1.00 | 0.82 | 8.07 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.3% | not timed | not timed | 4.45 ± 0.1% | 2.35 ± 6.7% | not timed | not timed | 1.35 ± 2.5% | | 1.00 | 0.30 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.19 ± 10.8% | not timed | not timed | 4.12 ± 0.2% | 5.99 ± 7.7% | not timed | not timed | 1.22 ± 0.4% | | 0.98 | 0.29 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 117.47 ± 1.6% | not timed | not timed | 82.76 ± 0.1% | 12.63 ± 13.2% | not timed | not timed | 117.35 ± 7.6% | | 1.00 | 1.42 | 9.30 |
| unicode/word/boundary-long-english | 3466 | 604.83 ± 0.3% | not timed | not timed | 607.14 ± 0.2% | 32.75 ± 0.3% | not timed | not timed | 605.83 ± 0.3% | | 1.00 | 1.00 | 18.47 |
| unicode/word/around-holmes-english | 27 | 602.24 ± 0.6% | not timed | not timed | 19447.33 ± 0.2% | 22.19 ± 1.2% | not timed | not timed | 601.01 ± 0.6% | | 1.00 | 0.0310 | 27.14 |
| wild/bibleref/long | 874 | 563.45 ± 0.3% | not timed | not timed | 580.75 ± 0.1% | 6.80 ± 0.1% | not timed | not timed | 563.95 ± 0.1% | | 1.00 | 0.97 | 82.85 |
| wild/bibleref/short | 30 | 23.64 ± 4.4% | not timed | not timed | 30.94 ± 0.2% | 13.68 ± 11.1% | not timed | not timed | 24.25 ± 3.6% | | 0.97 | 0.76 | 1.73 |
| wild/bibleref/line | 874 | 358.07 ± 0.2% | not timed | not timed | 212.54 ± 0.2% | 9.22 ± 0.4% | not timed | not timed | 358.81 ± 0.2% | | 1.00 | 1.68 | 38.82 |
| wild/caddy/caddy | 6 | 415.68 ± 2.6% | not timed | not timed | 250.14 ± 0.3% | 67.07 ± 14.0% | not timed | not timed | 415.99 ± 1.1% | | 1.00 | 1.66 | 6.20 |
| wild/dot-star-capture/rust-src-tools | 6 | 1048.53 ± 0.3% | not timed | not timed | 348.91 ± 0.3% | 13.50 ± 0.0% | not timed | not timed | 1049.38 ± 0.5% | | 1.00 | 3.01 | 77.68 |
| wild/ruff/noqa | 84 | 403.78 ± 0.1% | not timed | not timed | 464.10 ± 0.1% | 19.57 ± 2.2% | not timed | not timed | 403.22 ± 4.5% | | 1.00 | 0.87 | 20.63 |
| wild/ruff/unnecessary-coding-comment | 16 | 488.59 ± 0.7% | not timed | not timed | 699.04 ± 0.0% | 135.81 ± 10.5% | not timed | not timed | 488.58 ± 0.6% | | 1.00 | 0.70 | 3.60 |
| wild/ruff/string-quote-prefix | 2972 | 406.47 ± 0.6% | not timed | not timed | 406.58 ± 0.3% | 313.87 ± 25.1% | not timed | not timed | 407.23 ± 0.5% | | 1.00 | 1.00 | 1.30 |
| wild/ruff/space-around-operator | 1224378 | 217.33 ± 2.8% | not timed | not timed | 185.16 ± 0.2% | 18.34 ± 1.6% | not timed | not timed | 217.89 ± 1.8% | | 1.00 | 1.17 | 11.85 |
| wild/ruff/shebang | 282 | 400.48 ± 0.4% | not timed | not timed | 330.82 ± 0.1% | 111.28 ± 11.7% | not timed | not timed | 401.00 ± 0.4% | | 1.00 | 1.21 | 3.60 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13867.60 ± 0.3% | not timed | not timed | 13857.38 ± 0.4% | 6904.11 ± 1.0% | not timed | not timed | 13879.87 ± 0.2% | | 1.00 | 1.00 | 2.01 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12846.44 ± 0.4% | not timed | not timed | 13546.03 ± 0.7% | 6421.24 ± 0.2% | not timed | not timed | 12846.42 ± 0.3% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13194.50 ± 0.7% | not timed | not timed | 13668.78 ± 0.3% | 6673.07 ± 1.1% | not timed | not timed | 13219.70 ± 0.2% | | 1.00 | 0.97 | 1.98 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9573.84 ± 0.2% | not timed | not timed | 13591.97 ± 0.5% | 6726.60 ± 0.6% | not timed | not timed | 9583.41 ± 0.2% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 122.74 ± 13.7% | not timed | not timed | 65.87 ± 0.3% | 2.21 ± 0.7% | not timed | not timed | 123.06 ± 14.3% | | 1.00 | 1.86 | 55.46 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 11.1% | not timed | not timed | 0.01 ± 1.6% | 0.01 ± 13.2% | not timed | not timed | 0.03 ± 2.0% | | 0.99 | 3.05 | 4.05 |
| dictionary/compile/english-15 | 1 | 0.34 ± 4.5% | not timed | not timed | 0.07 ± 0.5% | 0.10 ± 13.3% | not timed | not timed | 0.35 ± 19.1% | | 0.99 | 4.91 | 3.34 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 0.5% | not timed | not timed | 0.02 ± 1.0% | 36.06 ± 4.1% | not timed | not timed | 0.25 ± 1.9% | | 1.03 | 13.26 | 0.0071 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.60 ± 16.7% | not timed | not timed | 11.52 ± 0.3% | 59.22 ± 20.9% | not timed | not timed | 46.85 ± 1.9% | | 0.99 | 4.05 | 0.79 |
| reported/i787-keywords/compile | 1 | 35.06 ± 16.9% | not timed | not timed | 2.13 ± 1.0% | 17.02 ± 21.6% | not timed | not timed | 35.31 ± 2.3% | | 0.99 | 16.48 | 2.06 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 348.01 ± 1.5% | not timed | not timed | 120.51 ± 0.2% | 563.02 ± 14.5% | not timed | not timed | 349.15 ± 1.7% | | 1.00 | 2.89 | 0.62 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.52 ± 2.0% | not timed | not timed | 4.14 ± 0.7% | 42.30 ± 14.6% | not timed | not timed | 47.76 ± 2.6% | | 0.99 | 11.49 | 1.12 |
| unicode/compile/one-letter | 53 | 6.70 ± 2.8% | not timed | not timed | 4.57 ± 0.4% | 65.50 ± 2.5% | not timed | not timed | 6.73 ± 13.5% | | 1.00 | 1.47 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.04 ± 4.0% | not timed | not timed | 0.10 ± 0.5% | 66.68 ± 7.7% | not timed | not timed | 1.08 ± 13.1% | | 0.96 | 10.32 | 0.0156 |
| unicode/compile/fifty-letters-ascii | 1 | 214.12 ± 2.1% | not timed | not timed | 53.17 ± 0.1% | 188.76 ± 17.7% | not timed | not timed | 217.82 ± 3.1% | | 0.98 | 4.03 | 1.13 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 375.64 ± 24.9% | not timed | not timed | 47.39 ± 0.3% | 672.56 ± 30.7% | not timed | not timed | 376.90 ± 1.9% | | 1.00 | 7.93 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 585.01 ± 14.5% | not timed | not timed | 144.82 ± 0.6% | 646.15 ± 13.9% | not timed | not timed | 603.25 ± 4.0% | | 0.97 | 4.04 | 0.91 |
| unicode/compile/negated-class-matches-codepoint | 1 | 302.83 ± 4.8% | not timed | not timed | 51.15 ± 0.2% | 1256.42 ± 2.2% | not timed | not timed | 313.75 ± 4.8% | | 0.97 | 5.92 | 0.24 |
| wild/bibleref/compile | 3 | 5.89 ± 4.0% | not timed | not timed | 1.95 ± 0.9% | 31.91 ± 5.9% | not timed | not timed | 5.90 ± 2.6% | | 1.00 | 3.02 | 0.18 |
| wild/url/compile | 1 | 0.55 ± 16.4% | not timed | not timed | 0.15 ± 0.7% | 0.45 ± 35.1% | not timed | not timed | 0.63 ± 19.0% | | 0.87 | 3.77 | 1.22 |

