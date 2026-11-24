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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391485948 |
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
| literal: a word | 217 | 19251.68 ± 2.4% | 5033.58 ± 0.1% | 28.11 ± 0.3% | 18163.29 ± 2.1% | 9307.42 ± 7.1% | 17.23 ± 0.3% | 84.23 ± 0.4% | 19279.26 ± 1.1% | 3.82 | 1.00 | 1.06 | 2.07 |
| literal: a word that is not there | 0 | 21751.95 ± 2.7% | 4914.22 ± 0.4% | 28.23 ± 0.5% | 19573.75 ± 1.5% | 28663.45 ± 2.1% | 17.02 ± 0.2% | 79.51 ± 0.3% | 21528.08 ± 2.3% | 4.43 | 1.01 | 1.11 | 0.76 |
| literal: one of four words | 661 | 6355.05 ± 0.1% | 1949.44 ± 0.2% | 14.36 ± 0.2% | 3942.48 ± 0.3% | 21.86 ± 0.1% | 5.36 ± 0.4% | 6.88 ± 0.5% | 6354.29 ± 0.2% | 3.26 | 1.00 | 1.61 | 290.78 |
| literal: a word in any case | 217 | 15039.23 ± 0.7% | 2087.70 ± 0.4% | 21.30 ± 0.3% | 3975.92 ± 0.1% | 38.02 ± 0.1% | refused | differs | 15084.15 ± 1.1% | 7.20 | 1.00 | 3.78 | 395.55 |
| literal: an href attribute | 33 | 16748.29 ± 0.8% | 609.53 ± 0.1% | 27.17 ± 0.2% | 16920.93 ± 1.8% | 2262.74 ± 0.3% | 13.11 ± 0.2% | 73.87 ± 0.9% | 16826.10 ± 0.6% | 27.48 | 1.00 | 0.99 | 7.40 |
| literal: a word, second text | 123 | 20136.81 ± 1.9% | 3390.44 ± 0.3% | 27.73 ± 0.2% | 18634.09 ± 2.0% | 7711.13 ± 6.9% | 20.15 ± 0.3% | 69.78 ± 0.6% | 20124.66 ± 0.9% | 5.94 | 1.00 | 1.08 | 2.61 |
| class: two capitalized words | 1331 | 1070.84 ± 0.3% | 598.87 ± 0.2% | 26.04 ± 0.2% | 585.36 ± 0.1% | 40.60 ± 2.0% | 14.65 ± 0.3% | 67.42 ± 0.3% | 1070.41 ± 0.1% | 1.79 | 1.00 | 1.83 | 26.38 |
| class: a word that ends in ing | 3399 | 573.13 ± 0.1% | 572.90 ± 0.3% | 17.96 ± 2.5% | 547.71 ± 0.1% | 29.63 ± 12.0% | 8.17 ± 0.2% | 18.40 ± 0.3% | 573.36 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.34 |
| class: a word in capitals | 2332 | 1374.01 ± 0.3% | 604.86 ± 0.2% | 27.53 ± 0.4% | 572.50 ± 0.1% | 43.58 ± 17.1% | 17.19 ± 0.2% | 82.37 ± 0.2% | 1378.55 ± 0.1% | 2.27 | 1.00 | 2.40 | 31.53 |
| class: a number | 8288 | 1999.64 ± 0.1% | 828.55 ± 0.1% | 27.53 ± 0.2% | 1727.55 ± 0.2% | 41.48 ± 16.6% | 0.54 ± 0.1% | 57.36 ± 0.2% | 2001.40 ± 0.3% | 2.41 | 1.00 | 1.16 | 48.20 |
| class: two capitalized words, second text | 5359 | 515.99 ± 0.0% | 523.57 ± 0.2% | 23.34 ± 0.1% | 485.45 ± 0.1% | 34.36 ± 14.6% | 17.10 ± 0.4% | 62.82 ± 0.3% | 515.64 ± 0.3% | 0.99 | 1.00 | 1.06 | 15.02 |
| other: a word between two words | 6104 | 788.48 ± 0.5% | 592.79 ± 0.2% | 23.51 ± 0.2% | 737.44 ± 0.3% | 108.53 ± 15.3% | 11.16 ± 0.3% | 68.15 ± 0.8% | 787.91 ± 0.1% | 1.33 | 1.00 | 1.07 | 7.27 |
| other: a number before a unit, second text | 1481 | 5936.36 ± 1.1% | 1119.31 ± 0.1% | 25.92 ± 0.3% | 5682.23 ± 0.5% | 40.80 ± 9.8% | 18.15 ± 0.2% | 65.74 ± 0.1% | 5972.90 ± 1.2% | 5.30 | 0.99 | 1.04 | 145.49 |
| other: a heading's start tag | 110 | 13998.42 ± 0.3% | 743.62 ± 0.1% | 27.27 ± 0.2% | 1708.43 ± 0.3% | 1573.54 ± 3.6% | 16.02 ± 0.6% | 86.17 ± 0.2% | 14039.06 ± 0.3% | 18.82 | 1.00 | 8.19 | 8.90 |
| other: a whole word | 217 | 15697.22 ± 3.2% | 603.34 ± 0.3% | 29.24 ± 0.4% | 14636.36 ± 1.8% | 49.44 ± 0.3% | 13.16 ± 0.1% | 54.98 ± 0.2% | 15801.36 ± 2.3% | 26.02 | 0.99 | 1.07 | 317.47 |
| other: a line's first word, second text | 3716 | 2043.95 ± 0.3% | 587.92 ± 0.1% | 30.91 ± 0.2% | 1726.65 ± 0.5% | 63.34 ± 6.9% | refused | refused | 2055.31 ± 0.4% | 3.48 | 0.99 | 1.18 | 32.27 |
| other: fourteen octets before an x | 87 | 23679.23 ± 1.8% | 247.58 ± 0.5% | 6.31 ± 0.3% | 4040.73 ± 3.9% | 10.62 ± 0.4% | differs | 17.73 ± 0.2% | 23443.09 ± 6.0% | 95.64 | 1.01 | 5.86 | 2229.02 |
| other: a Greek word | 21815 | 496.80 ± 0.3% | 412.47 ± 0.2% | 30.62 ± 0.1% | 289.59 ± 0.1% | 49.50 ± 11.5% | differs | refused | 500.99 ± 0.5% | 1.20 | 0.99 | 1.72 | 10.04 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.60 ± 0.2% | 19.55 ± 0.2% | 0.85 ± 0.1% | 19.87 ± 0.1% | 2.77 ± 0.4% | differs | 4.07 ± 0.4% | 19.56 ± 0.3% | 1.00 | 1.00 | 0.99 | 7.07 |
| a UUID | 32895 | 21.13 ± 0.1% | 21.11 ± 0.2% | 0.64 ± 0.1% | 15.09 ± 0.2% | 3.08 ± 0.6% | 0.73 ± 0.1% | 3.65 ± 0.7% | 21.11 ± 0.1% | 1.00 | 1.00 | 1.40 | 6.87 |
| an IPv4 address | 33176 | 36.02 ± 0.1% | 36.01 ± 0.2% | 2.05 ± 0.2% | 29.39 ± 0.2% | 6.66 ± 0.2% | differs | 4.17 ± 0.2% | 35.99 ± 0.2% | 1.00 | 1.00 | 1.23 | 5.41 |
| a date and time | 32954 | 30.98 ± 0.5% | 31.07 ± 0.5% | 1.43 ± 0.2% | 21.52 ± 0.3% | 7.04 ± 0.2% | 1.26 ± 0.2% | 7.17 ± 0.3% | 31.02 ± 0.5% | 1.00 | 1.00 | 1.44 | 4.40 |
| a field path | 32606 | 23.20 ± 0.4% | 23.15 ± 0.3% | 1.01 ± 0.2% | 23.25 ± 0.1% | 3.47 ± 0.6% | differs | 2.99 ± 0.2% | 23.14 ± 0.2% | 1.00 | 1.00 | 1.00 | 6.69 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.15 ± 0.8% | 11.16 ± 1.5% | 11.10 ± 1.0% | 11.55 ± 0.2% | 4.96 ± 1.2% | 0.94 ± 0.6% | none | 11.18 ± 0.6% | 1.00 | 1.00 | 0.97 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 231.82 ± 0.2% | 232.89 ± 0.1% | 275.16 ± 0.1% | 86.66 ± 0.1% | 219.42 ± 0.9% | 482.93 ± 0.4% | 3803.71 ± 0.9% | 231.93 ± 0.2% | 1.00 | 1.00 | 2.68 | 1.06 |
| a UUID | 62 | 153.07 ± 0.2% | 153.69 ± 0.3% | 170.98 ± 0.2% | 46.06 ± 0.6% | 99.21 ± 1.2% | 179.97 ± 1.9% | 4172.56 ± 1.5% | 153.19 ± 0.2% | 1.00 | 1.00 | 3.32 | 1.54 |
| an IPv4 address | 29 | 424.41 ± 0.2% | 428.90 ± 0.3% | 594.88 ± 0.8% | 76.23 ± 0.8% | 132.18 ± 1.1% | 294.70 ± 0.3% | 7517.33 ± 0.2% | 425.15 ± 0.4% | 0.99 | 1.00 | 5.57 | 3.21 |
| a date and time | 56 | 307.07 ± 0.1% | 309.87 ± 0.2% | 387.82 ± 0.1% | 72.83 ± 1.2% | 136.43 ± 1.2% | 319.68 ± 1.8% | 4801.65 ± 0.5% | 307.17 ± 0.2% | 0.99 | 1.00 | 4.22 | 2.25 |
| a field path | 39 | 225.14 ± 0.2% | 226.24 ± 0.2% | 265.65 ± 0.2% | 79.50 ± 0.5% | 204.66 ± 13.3% | 483.04 ± 1.3% | 4875.28 ± 2.6% | 225.28 ± 0.3% | 1.00 | 1.00 | 2.83 | 1.10 |
| literal: a word | 7 | 633.89 ± 0.8% | 686.97 ± 0.4% | 1231.75 ± 0.3% | 504.10 ± 1.1% | 630.07 ± 1.4% | 924.00 ± 0.5% | 31047.03 ± 0.3% | 634.12 ± 0.6% | 0.92 | 1.00 | 1.26 | 1.01 |
| literal: a word that is not there | 8 | 610.35 ± 0.3% | 663.01 ± 0.3% | 1162.60 ± 0.5% | 464.35 ± 0.8% | 599.76 ± 2.4% | 872.88 ± 0.6% | 29654.87 ± 0.1% | 609.92 ± 0.4% | 0.92 | 1.00 | 1.31 | 1.02 |
| literal: one of four words | 26 | 246.03 ± 0.1% | 397.88 ± 0.3% | 542.06 ± 0.4% | 49.14 ± 0.2% | 241.97 ± 0.8% | 355.83 ± 0.4% | 16143.28 ± 0.3% | 246.12 ± 0.4% | 0.62 | 1.00 | 5.01 | 1.02 |
| literal: a word in any case | 11 | 452.89 ± 0.4% | 484.88 ± 0.5% | 713.86 ± 0.1% | 15.68 ± 0.7% | 661.43 ± 1.9% | refused | 23937.09 ± 0.3% | 452.74 ± 0.2% | 0.93 | 1.00 | 28.88 | 0.68 |
| literal: an href attribute | 12 | 347.66 ± 0.5% | 360.26 ± 0.1% | 470.73 ± 0.2% | 45.08 ± 0.7% | 499.95 ± 1.1% | 748.88 ± 0.9% | 22292.25 ± 0.2% | 347.75 ± 0.4% | 0.97 | 1.00 | 7.71 | 0.70 |
| literal: a word, second text | 10 | 565.88 ± 0.7% | 625.31 ± 0.7% | 1047.96 ± 0.8% | 422.99 ± 0.7% | 533.38 ± 1.6% | 780.02 ± 0.3% | 27828.16 ± 0.2% | 565.77 ± 0.4% | 0.90 | 1.00 | 1.34 | 1.06 |
| class: two capitalized words | 23 | 438.58 ± 0.8% | 469.43 ± 0.7% | 672.67 ± 0.9% | 100.32 ± 1.2% | 503.89 ± 1.3% | 764.66 ± 0.8% | 6498.91 ± 0.5% | 438.40 ± 0.5% | 0.93 | 1.00 | 4.37 | 0.87 |
| class: a word that ends in ing | 9 | 569.72 ± 0.3% | 637.23 ± 0.1% | 1116.06 ± 0.3% | 132.40 ± 0.3% | 762.84 ± 1.1% | 1096.35 ± 0.9% | 16095.05 ± 0.2% | 570.33 ± 0.4% | 0.89 | 1.00 | 4.30 | 0.75 |
| class: a word in capitals | 16 | 495.75 ± 0.3% | 538.66 ± 0.2% | 851.62 ± 0.3% | 134.10 ± 0.5% | 749.37 ± 1.4% | 1007.98 ± 0.9% | 8593.34 ± 0.2% | 495.75 ± 0.2% | 0.92 | 1.00 | 3.70 | 0.66 |
| class: a number | 6 | 632.59 ± 1.3% | 695.91 ± 0.4% | 1299.50 ± 0.2% | 42.09 ± 1.0% | 1419.91 ± 0.3% | 1879.34 ± 0.6% | 23229.54 ± 0.2% | 633.09 ± 0.2% | 0.91 | 1.00 | 15.03 | 0.45 |
| class: two capitalized words, second text | 23 | 438.22 ± 0.8% | 470.37 ± 0.3% | 673.05 ± 0.6% | 101.31 ± 3.5% | 506.94 ± 0.9% | 757.47 ± 0.6% | 6505.59 ± 0.7% | 438.81 ± 0.5% | 0.93 | 1.00 | 4.33 | 0.86 |
| other: a word between two words | 13 | 549.72 ± 0.6% | 570.63 ± 0.4% | 905.38 ± 0.3% | 135.03 ± 1.0% | 500.17 ± 8.7% | 821.18 ± 1.1% | 14685.90 ± 0.6% | 550.78 ± 0.3% | 0.96 | 1.00 | 4.07 | 1.10 |
| other: a number before a unit, second text | 15 | 404.05 ± 0.4% | 443.38 ± 0.3% | 622.29 ± 0.2% | 39.43 ± 0.3% | 631.18 ± 0.6% | 892.06 ± 0.4% | 15416.52 ± 0.3% | 403.85 ± 0.2% | 0.91 | 1.00 | 10.25 | 0.64 |
| other: a heading's start tag | 13 | 360.47 ± 0.4% | 367.01 ± 0.6% | 482.04 ± 0.4% | 43.36 ± 0.4% | 623.86 ± 0.9% | 862.17 ± 0.3% | 18407.37 ± 0.6% | 360.81 ± 0.4% | 0.98 | 1.00 | 8.31 | 0.58 |
| other: a whole word | 11 | 582.89 ± 0.4% | 621.27 ± 0.2% | 1041.50 ± 0.1% | 120.64 ± 0.3% | 566.29 ± 2.0% | 832.00 ± 0.6% | 27492.21 ± 0.5% | 582.49 ± 0.6% | 0.94 | 1.00 | 4.83 | 1.03 |
| other: a line's first word, second text | 17 | 530.18 ± 0.5% | 557.78 ± 0.5% | 892.17 ± 0.7% | 129.29 ± 0.3% | 714.72 ± 0.9% | refused | refused | 532.32 ± 0.2% | 0.95 | 1.00 | 4.10 | 0.74 |
| other: fourteen octets before an x | 16 | 110.13 ± 0.8% | 158.16 ± 1.2% | 180.61 ± 1.0% | 15.19 ± 0.3% | 456.16 ± 0.9% | 409.65 ± 0.5% | 12984.29 ± 0.1% | 110.38 ± 0.4% | 0.70 | 1.00 | 7.25 | 0.24 |
| other: a Greek word | 8 | 454.69 ± 0.1% | 604.51 ± 0.2% | 1016.43 ± 0.2% | 59.05 ± 0.6% | 1385.20 ± 1.2% | 1786.22 ± 0.2% | refused | 454.93 ± 0.2% | 0.75 | 1.00 | 7.70 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15689.08 ± 1.2% | not timed | not timed | 16227.34 ± 2.0% | 2110.10 ± 17.0% | not timed | not timed | 15599.48 ± 1.7% | | 1.01 | 0.97 | 7.44 |
| 01-literal/sherlock-casei-en | 522 | 11100.43 ± 4.2% | not timed | not timed | 3595.18 ± 0.2% | 32.51 ± 10.4% | not timed | not timed | 11084.51 ± 3.1% | | 1.00 | 3.09 | 341.45 |
| 01-literal/sherlock-ru | 724 | 17109.28 ± 0.7% | not timed | not timed | 17340.59 ± 0.6% | 1492.95 ± 13.0% | not timed | not timed | 17180.83 ± 0.4% | | 1.00 | 0.99 | 11.46 |
| 01-literal/sherlock-casei-ru | 746 | 6182.73 ± 0.2% | not timed | not timed | 3332.27 ± 0.1% | 30.84 ± 0.2% | not timed | not timed | 6177.83 ± 0.2% | | 1.00 | 1.86 | 200.50 |
| 01-literal/sherlock-zh | 30 | 19604.99 ± 1.2% | not timed | not timed | 18479.48 ± 1.8% | 2778.37 ± 10.3% | not timed | not timed | 19625.66 ± 0.5% | | 1.00 | 1.06 | 7.06 |
| 02-literal-alternate/sherlock-en | 714 | 6061.16 ± 0.5% | not timed | not timed | 3936.33 ± 0.1% | 16.63 ± 0.2% | not timed | not timed | 6064.09 ± 0.3% | | 1.00 | 1.54 | 364.49 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1981.44 ± 1.0% | not timed | not timed | 699.41 ± 0.3% | 11.12 ± 0.1% | not timed | not timed | 1987.27 ± 1.1% | | 1.00 | 2.83 | 178.21 |
| 02-literal-alternate/sherlock-ru | 899 | 5570.26 ± 0.5% | not timed | not timed | 3251.86 ± 0.2% | 22.60 ± 0.1% | not timed | not timed | 5568.01 ± 0.2% | | 1.00 | 1.71 | 246.45 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2059.29 ± 0.5% | not timed | not timed | 1227.80 ± 0.6% | 9.11 ± 0.2% | not timed | not timed | 2059.61 ± 0.4% | | 1.00 | 1.68 | 226.07 |
| 02-literal-alternate/sherlock-zh | 207 | 7315.99 ± 0.3% | not timed | not timed | 4165.60 ± 0.1% | 31.53 ± 0.1% | not timed | not timed | 7303.48 ± 0.2% | | 1.00 | 1.76 | 232.04 |
| 03-date/ascii | 111817 | 124.30 ± 0.5% | not timed | not timed | 95.63 ± 0.1% | 0.20 ± 3.1% | not timed | not timed | 124.54 ± 0.7% | | 1.00 | 1.30 | 615.00 |
| 04-ruff-noqa/real | 84 | 404.30 ± 0.0% | not timed | not timed | 479.12 ± 0.1% | 19.66 ± 1.6% | not timed | not timed | 403.56 ± 0.2% | | 1.00 | 0.84 | 20.57 |
| 04-ruff-noqa/tweaked | 44 | 555.26 ± 0.1% | not timed | not timed | 462.21 ± 0.0% | 366.11 ± 0.6% | not timed | not timed | 556.47 ± 0.5% | | 1.00 | 1.20 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.54 ± 0.6% | not timed | not timed | 5.17 ± 0.1% | 0.20 ± 4.6% | not timed | not timed | 5.41 ± 4.8% | | 1.02 | 1.07 | 27.70 |
| 06-cloud-flare-redos/original | 107 | 414.98 ± 5.1% | not timed | not timed | 215.05 ± 0.1% | 24.56 ± 4.0% | not timed | not timed | 415.67 ± 10.5% | | 1.00 | 1.93 | 16.89 |
| 06-cloud-flare-redos/simplified-short | 102 | 414.52 ± 0.2% | not timed | not timed | 226.67 ± 0.1% | 26.66 ± 2.4% | not timed | not timed | 409.73 ± 0.5% | | 1.01 | 1.83 | 15.55 |
| 06-cloud-flare-redos/simplified-long | 10000 | 588.05 ± 0.2% | not timed | not timed | 254.89 ± 0.3% | 28.74 ± 0.4% | not timed | not timed | 578.53 ± 0.1% | | 1.02 | 2.31 | 20.46 |
| 07-unicode-character-data/parse-line | 558784 | 237.11 ± 0.8% | not timed | not timed | 180.69 ± 0.2% | 42.84 ± 1.9% | not timed | not timed | 238.50 ± 0.8% | | 0.99 | 1.31 | 5.53 |
| 08-words/all-english | 56691 | 116.18 ± 0.4% | not timed | not timed | 82.70 ± 0.1% | 13.01 ± 11.7% | not timed | not timed | 117.30 ± 0.5% | | 0.99 | 1.40 | 8.93 |
| 08-words/long-english | 839 | 615.41 ± 0.8% | not timed | not timed | 596.01 ± 0.1% | 32.63 ± 0.3% | not timed | not timed | 613.97 ± 0.6% | | 1.00 | 1.03 | 18.86 |
| 09-aws-keys/full | 0 | 408.41 ± 0.1% | not timed | not timed | 475.68 ± 0.2% | 64.56 ± 0.2% | not timed | not timed | 408.93 ± 0.1% | | 1.00 | 0.86 | 6.33 |
| 09-aws-keys/quick | 0 | 872.64 ± 0.2% | not timed | not timed | 999.13 ± 0.5% | 419.46 ± 1.3% | not timed | not timed | 872.74 ± 0.2% | | 1.00 | 0.87 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 578.27 ± 2.2% | not timed | not timed | 517.51 ± 0.7% | 19.28 ± 0.7% | not timed | not timed | 579.35 ± 0.5% | | 1.00 | 1.12 | 29.99 |
| 10-bounded-repeat/letters-ru | 3475 | 509.43 ± 1.6% | not timed | not timed | 478.95 ± 0.5% | 22.11 ± 9.5% | not timed | not timed | 498.22 ± 0.9% | | 1.02 | 1.06 | 23.04 |
| 10-bounded-repeat/context | 53 | 85.27 ± 1.9% | not timed | not timed | 65.91 ± 0.5% | 19.81 ± 0.4% | not timed | not timed | 85.38 ± 1.7% | | 1.00 | 1.29 | 4.30 |
| 10-bounded-repeat/capitals | 11 | 641.35 ± 8.0% | not timed | not timed | 618.38 ± 0.1% | 36.52 ± 0.2% | not timed | not timed | 640.79 ± 8.0% | | 1.00 | 1.04 | 17.56 |
| 11-unstructured-to-json/extract | 600 | 56.68 ± 1.3% | not timed | not timed | 77.19 ± 0.1% | 49.00 ± 0.4% | not timed | not timed | 56.80 ± 0.2% | | 1.00 | 0.73 | 1.16 |
| 12-dictionary/single | 1 | 566.97 ± 0.3% | not timed | not timed | 558.30 ± 0.0% | 0.40 ± 0.1% | not timed | not timed | 568.09 ± 0.2% | | 1.00 | 1.02 | 1402.49 |
| 14-quadratic/1x | 100 | 21.20 ± 1.9% | not timed | not timed | 10.00 ± 0.3% | 0.96 ± 3.2% | not timed | not timed | 21.20 ± 2.0% | | 1.00 | 2.12 | 22.06 |
| 14-quadratic/2x | 200 | 17.42 ± 0.8% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 0.8% | not timed | not timed | 17.37 ± 0.6% | | 1.00 | 3.14 | 32.69 |
| 14-quadratic/10x | 1000 | 7.68 ± 0.4% | not timed | not timed | 1.21 ± 0.1% | 0.11 ± 1.7% | not timed | not timed | 7.69 ± 0.5% | | 1.00 | 6.35 | 66.83 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.26 ± 3.0% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 3.9% | not timed | not timed | 1.27 ± 2.6% | | 1.00 | 3.68 | 2.30 |
| 04-ruff-noqa/compile-real | 1 | 106.05 ± 0.9% | not timed | not timed | 13.83 ± 0.4% | 138.24 ± 1.3% | not timed | not timed | 107.01 ± 1.1% | | 0.99 | 7.67 | 0.77 |
| 05-lexer-veryl/compile-single | 1 | 14.11 ± 0.4% | not timed | not timed | 2.52 ± 0.5% | 6.37 ± 15.8% | not timed | not timed | 14.16 ± 1.0% | | 1.00 | 5.61 | 2.22 |
| 07-unicode-character-data/compile | 1 | 109.38 ± 1.3% | not timed | not timed | 25.91 ± 0.2% | 35.93 ± 4.1% | not timed | not timed | 109.98 ± 0.8% | | 0.99 | 4.22 | 3.04 |
| 09-aws-keys/compile-full | 1 | 53.43 ± 0.8% | not timed | not timed | 8.24 ± 0.8% | 23.31 ± 2.9% | not timed | not timed | 53.63 ± 0.8% | | 1.00 | 6.48 | 2.29 |
| 09-aws-keys/compile-quick | 1 | 188.55 ± 1.1% | not timed | not timed | 46.78 ± 0.1% | 130.88 ± 13.8% | not timed | not timed | 189.86 ± 1.0% | | 0.99 | 4.03 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 72.68 ± 0.5% | not timed | not timed | 11.00 ± 0.4% | 15.74 ± 2.5% | not timed | not timed | 73.13 ± 1.6% | | 0.99 | 6.60 | 4.62 |
| 10-bounded-repeat/compile-capitals | 1 | 84.52 ± 1.2% | not timed | not timed | 7.94 ± 0.7% | 23.64 ± 1.4% | not timed | not timed | 85.14 ± 1.4% | | 0.99 | 10.64 | 3.57 |
| 11-unstructured-to-json/compile | 1 | 174.30 ± 0.5% | not timed | not timed | 40.95 ± 0.8% | 67.50 ± 2.1% | not timed | not timed | 174.29 ± 1.2% | | 1.00 | 4.26 | 2.58 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.5% | not timed | not timed | 0.07 ± 1.5% | 0.09 ± 8.0% | not timed | not timed | 0.35 ± 0.6% | | 1.00 | 5.10 | 3.72 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.63 ± 0.8% | not timed | not timed | 6.58 ± 0.1% | 0.53 ± 2.0% | not timed | not timed | 7.61 ± 0.4% | | 1.00 | 1.16 | 14.50 |
| dictionary/search/english-10 | 690 | 1.05 ± 0.3% | not timed | not timed | 165.37 ± 0.7% | 0.00 ± 0.5% | not timed | not timed | 1.05 ± 0.3% | | 1.00 | 0.0063 | 378.06 |
| dictionary/search/english-15 | 15 | 559.68 ± 0.3% | not timed | not timed | 560.93 ± 0.1% | 0.37 ± 0.3% | not timed | not timed | 561.85 ± 0.3% | | 1.00 | 1.00 | 1512.44 |
| folly/awyer-inn-busted | 1 | 5585.84 ± 0.1% | not timed | not timed | 143.53 ± 0.1% | 43.95 ± 6.8% | not timed | not timed | 5574.28 ± 0.2% | | 1.00 | 38.92 | 127.09 |
| folly/literal-never-match-rare | 0 | 21085.42 ± 0.4% | not timed | not timed | 19913.12 ± 0.3% | 40883.23 ± 0.4% | not timed | not timed | 21112.44 ± 0.3% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12516.88 ± 0.8% | not timed | not timed | 19842.76 ± 0.2% | 2181.84 ± 1.0% | not timed | not timed | 12551.99 ± 0.7% | | 1.00 | 0.63 | 5.74 |
| folly/literal-never-match-tricksy | 1 | 3244.51 ± 0.4% | not timed | not timed | 4409.73 ± 0.1% | 3056.05 ± 0.6% | not timed | not timed | 3255.05 ± 0.5% | | 1.00 | 0.74 | 1.06 |
| grep/every-line | 239963 | 1310.07 ± 0.5% | not timed | not timed | 959.47 ± 1.0% | 373.15 ± 21.8% | not timed | not timed | 1310.14 ± 0.5% | | 1.00 | 1.37 | 3.51 |
| grep/long-words-ascii | 5073 | 460.01 ± 0.2% | not timed | not timed | 469.81 ± 0.1% | 46.20 ± 8.1% | not timed | not timed | 435.86 ± 0.5% | | 1.06 | 0.98 | 9.96 |
| imported/leipzig/twain | 811 | 20590.83 ± 0.7% | not timed | not timed | 19542.61 ± 0.6% | 11905.66 ± 9.8% | not timed | not timed | 20649.74 ± 0.9% | | 1.00 | 1.05 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9037.40 ± 0.9% | not timed | not timed | 4246.27 ± 0.3% | 37.69 ± 0.3% | not timed | not timed | 9056.59 ± 1.4% | | 1.00 | 2.13 | 239.78 |
| imported/leipzig/shing | 1540 | 629.65 ± 0.0% | not timed | not timed | 13078.90 ± 1.4% | 34.04 ± 0.1% | not timed | not timed | 631.74 ± 0.1% | | 1.00 | 0.0481 | 18.50 |
| imported/leipzig/huck-saw | 262 | 8191.21 ± 2.7% | not timed | not timed | 5594.32 ± 0.4% | 31.64 ± 0.1% | not timed | not timed | 8363.79 ± 3.4% | | 0.98 | 1.46 | 258.87 |
| imported/leipzig/word-ending-nn | 262 | 608.50 ± 0.2% | not timed | not timed | 616.28 ± 0.2% | 24.75 ± 0.3% | not timed | not timed | 611.25 ± 0.1% | | 1.00 | 0.99 | 24.59 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11071.87 ± 1.1% | not timed | not timed | 4490.63 ± 0.8% | 11.52 ± 0.1% | not timed | not timed | 11089.52 ± 1.2% | | 1.00 | 2.47 | 961.03 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7712.16 ± 2.0% | not timed | not timed | 5467.55 ± 0.5% | 16.89 ± 0.1% | not timed | not timed | 7811.43 ± 2.6% | | 0.99 | 1.41 | 456.55 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4174.70 ± 1.7% | not timed | not timed | 411.11 ± 1.6% | 11.10 ± 0.1% | not timed | not timed | 4187.56 ± 1.0% | | 1.00 | 10.15 | 376.06 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 609.44 ± 0.2% | not timed | not timed | 615.15 ± 0.1% | 11.11 ± 0.2% | not timed | not timed | 609.98 ± 0.2% | | 1.00 | 0.99 | 54.86 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.74 ± 0.1% | not timed | not timed | 615.56 ± 0.0% | 9.75 ± 0.0% | not timed | not timed | 610.29 ± 0.1% | | 1.00 | 0.99 | 62.54 |
| imported/leipzig/tom-river | 2 | 6487.88 ± 3.2% | not timed | not timed | 5122.19 ± 0.6% | 31.02 ± 0.1% | not timed | not timed | 6501.85 ± 2.5% | | 1.00 | 1.27 | 209.12 |
| imported/leipzig/ing | 78424 | 608.97 ± 0.4% | not timed | not timed | 570.74 ± 0.1% | 28.16 ± 3.4% | not timed | not timed | 607.51 ± 0.6% | | 1.00 | 1.07 | 21.63 |
| imported/leipzig/ing-whitespace | 55248 | 757.48 ± 0.8% | not timed | not timed | 2055.48 ± 0.4% | 20.53 ± 2.9% | not timed | not timed | 757.88 ± 0.2% | | 1.00 | 0.37 | 36.90 |
| imported/leipzig/awyer-inn | 209 | 774.30 ± 1.4% | not timed | not timed | 4166.13 ± 3.5% | 22.73 ± 0.1% | not timed | not timed | 774.67 ± 1.5% | | 1.00 | 0.19 | 34.07 |
| imported/leipzig/quotes-bounded | 8886 | 2115.46 ± 0.4% | not timed | not timed | 2979.96 ± 0.5% | 38.13 ± 0.1% | not timed | not timed | 2110.33 ± 0.6% | | 1.00 | 0.71 | 55.48 |
| imported/leipzig/non-ascii-alternate | 2 | 12623.05 ± 2.1% | not timed | not timed | 5653.01 ± 0.3% | 50.49 ± 0.1% | not timed | not timed | 12836.12 ± 3.0% | | 0.98 | 2.23 | 250.01 |
| imported/leipzig/math-symbols | 69 | 1972.83 ± 0.5% | not timed | not timed | 619.09 ± 0.1% | 36.60 ± 0.0% | not timed | not timed | 1975.74 ± 0.5% | | 1.00 | 3.19 | 53.90 |
| imported/leipzig/bounded-strings-ending-z | 0 | 595.84 ± 0.5% | not timed | not timed | 617.70 ± 0.1% | 22.55 ± 0.2% | not timed | not timed | 593.08 ± 0.3% | | 1.00 | 0.96 | 26.42 |
| imported/lh3lh3-reb/uri | 17549 | 633.04 ± 0.1% | not timed | not timed | 1076.37 ± 0.2% | 28.51 ± 2.4% | not timed | not timed | 633.31 ± 0.2% | | 1.00 | 0.59 | 22.21 |
| imported/lh3lh3-reb/email | 15057 | 667.97 ± 0.1% | not timed | not timed | 1172.74 ± 0.2% | 30.30 ± 2.4% | not timed | not timed | 669.29 ± 0.1% | | 1.00 | 0.57 | 22.05 |
| imported/lh3lh3-reb/date | 668 | 865.83 ± 0.2% | not timed | not timed | 1043.41 ± 0.2% | 51.24 ± 3.8% | not timed | not timed | 866.32 ± 0.2% | | 1.00 | 0.83 | 16.90 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 642.61 ± 0.1% | not timed | not timed | 422.44 ± 0.2% | 15.78 ± 1.5% | not timed | not timed | 643.29 ± 0.1% | | 1.00 | 1.52 | 40.72 |
| imported/mariomka/email | 92 | 705.38 ± 0.2% | not timed | not timed | 29368.87 ± 0.8% | 32.86 ± 0.1% | not timed | not timed | 706.48 ± 0.2% | | 1.00 | 0.0240 | 21.47 |
| imported/mariomka/uri | 5301 | 608.18 ± 0.1% | not timed | not timed | 5974.67 ± 0.3% | 32.77 ± 0.2% | not timed | not timed | 605.85 ± 0.1% | | 1.00 | 0.10 | 18.56 |
| imported/mariomka/ip | 5 | 2153.09 ± 2.2% | not timed | not timed | 2964.37 ± 0.2% | 21.09 ± 0.2% | not timed | not timed | 2153.10 ± 2.4% | | 1.00 | 0.73 | 102.09 |
| imported/rsc/no-exponential | 0 | 564.88 ± 0.1% | not timed | not timed | 320.03 ± 0.1% | 23.88 ± 0.3% | not timed | not timed | 564.78 ± 0.1% | | 1.00 | 1.77 | 23.66 |
| imported/rsc/literal | 1 | 750.88 ± 7.5% | not timed | not timed | 1555.32 ± 5.6% | 190.52 ± 18.4% | not timed | not timed | 750.26 ± 8.0% | | 1.00 | 0.48 | 3.94 |
| imported/rsc/not-literal | 2 | 707.65 ± 1.9% | not timed | not timed | 731.29 ± 0.5% | 46.43 ± 9.8% | not timed | not timed | 706.63 ± 0.1% | | 1.00 | 0.97 | 15.24 |
| imported/rsc/match-class | 1 | 1301.83 ± 0.5% | not timed | not timed | 1620.03 ± 0.1% | 58.68 ± 1.7% | not timed | not timed | 1305.55 ± 9.1% | | 1.00 | 0.80 | 22.19 |
| imported/rsc/match-class-in-range | 1 | 1313.76 ± 0.3% | not timed | not timed | 2322.11 ± 4.9% | 60.13 ± 14.8% | not timed | not timed | 1310.62 ± 2.1% | | 1.00 | 0.57 | 21.85 |
| imported/rsc/match-class-unicode | 1 | 524.71 ± 0.2% | not timed | not timed | 512.99 ± 0.0% | 72.81 ± 0.2% | not timed | not timed | 523.81 ± 0.0% | | 1.00 | 1.02 | 7.21 |
| imported/rsc/anchored-literal-short-non-match | 0 | 539.04 ± 0.7% | not timed | not timed | 940.80 ± 0.3% | 227.43 ± 1.0% | not timed | not timed | 535.77 ± 0.6% | | 1.01 | 0.57 | 2.37 |
| imported/rsc/anchored-literal-long-non-match | 0 | 8054.18 ± 0.3% | not timed | not timed | 14148.37 ± 0.1% | 3404.92 ± 0.6% | not timed | not timed | 8029.53 ± 0.7% | | 1.00 | 0.57 | 2.37 |
| imported/rsc/anchored-literal-short-match | 4 | 409.81 ± 5.7% | not timed | not timed | 478.94 ± 0.3% | 84.29 ± 8.4% | not timed | not timed | 417.30 ± 2.4% | | 0.98 | 0.86 | 4.86 |
| imported/rsc/anchored-literal-long-match | 4 | 3019.76 ± 2.7% | not timed | not timed | 7210.52 ± 0.3% | 1243.61 ± 12.2% | not timed | not timed | 3020.50 ± 3.6% | | 1.00 | 0.42 | 2.43 |
| imported/rsc/one-pass-short | 17 | 305.13 ± 8.6% | not timed | not timed | 216.37 ± 0.6% | 31.04 ± 10.6% | not timed | not timed | 309.46 ± 0.1% | | 0.99 | 1.41 | 9.83 |
| imported/rsc/one-pass-short-not | 17 | 219.41 ± 1.8% | not timed | not timed | 223.98 ± 0.2% | 30.31 ± 14.0% | not timed | not timed | 218.66 ± 5.3% | | 1.00 | 0.98 | 7.24 |
| imported/rsc/one-pass-long-prefix | 26 | 237.18 ± 8.6% | not timed | not timed | 285.45 ± 0.5% | 97.96 ± 15.1% | not timed | not timed | 240.47 ± 3.9% | | 0.99 | 0.83 | 2.42 |
| imported/rsc/one-pass-long-prefix-not | 26 | 307.38 ± 7.1% | not timed | not timed | 284.77 ± 0.3% | 70.60 ± 19.9% | not timed | not timed | 308.20 ± 0.2% | | 1.00 | 1.08 | 4.35 |
| imported/rsc/long-needle1 | 31 | 21954.17 ± 0.4% | not timed | not timed | 20185.99 ± 0.1% | 3.72 ± 0.1% | not timed | not timed | 21953.16 ± 0.1% | | 1.00 | 1.09 | 5897.39 |
| imported/rsc/long-needle2 | 31 | 22093.27 ± 0.1% | not timed | not timed | 215.91 ± 0.1% | 3.76 ± 0.1% | not timed | not timed | 22099.03 ± 0.1% | | 1.00 | 102.33 | 5879.94 |
| imported/rsc/easy0-32 | 26 | 1072.75 ± 2.8% | not timed | not timed | 1526.86 ± 0.3% | 145.84 ± 17.1% | not timed | not timed | 1071.98 ± 0.4% | | 1.00 | 0.70 | 7.36 |
| imported/rsc/easy0-1k | 26 | 14977.02 ± 2.3% | not timed | not timed | 12358.18 ± 0.4% | 2320.64 ± 14.1% | not timed | not timed | 14992.11 ± 0.2% | | 1.00 | 1.21 | 6.45 |
| imported/rsc/easy0-32k | 26 | 22902.39 ± 0.4% | not timed | not timed | 20478.02 ± 0.3% | 18788.83 ± 0.1% | not timed | not timed | 22916.47 ± 0.4% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21915.14 ± 0.5% | not timed | not timed | 20136.45 ± 0.9% | 38163.31 ± 1.6% | not timed | not timed | 21911.04 ± 1.2% | | 1.00 | 1.09 | 0.57 |
| imported/rsc/easy1-32 | 19 | 359.33 ± 2.2% | not timed | not timed | 622.02 ± 0.3% | 131.31 ± 20.1% | not timed | not timed | 359.44 ± 2.1% | | 1.00 | 0.58 | 2.74 |
| imported/rsc/easy1-1k | 19 | 585.32 ± 0.1% | not timed | not timed | 12705.99 ± 0.1% | 2471.62 ± 17.9% | not timed | not timed | 581.21 ± 2.7% | | 1.01 | 0.0461 | 0.24 |
| imported/rsc/easy1-32k | 19 | 601.45 ± 2.8% | not timed | not timed | 402957.69 ± 0.2% | 20366.34 ± 31.1% | not timed | not timed | 600.23 ± 0.2% | | 1.00 | 0.0015 | 0.0295 |
| imported/rsc/easy1-1mb | 19 | 603.83 ± 0.1% | not timed | not timed | 12796053.14 ± 0.1% | 36434.41 ± 4.3% | not timed | not timed | 601.76 ± 0.4% | | 1.00 | 0.0000 | 0.0166 |
| imported/rsc/medium-32 | 27 | 430.05 ± 0.2% | not timed | not timed | 634.08 ± 0.9% | 70.07 ± 10.7% | not timed | not timed | 428.53 ± 1.9% | | 1.00 | 0.68 | 6.14 |
| imported/rsc/medium-1k | 27 | 6817.91 ± 0.1% | not timed | not timed | 11146.49 ± 0.3% | 72.44 ± 0.4% | not timed | not timed | 6799.64 ± 0.2% | | 1.00 | 0.61 | 94.12 |
| imported/rsc/medium-32k | 27 | 21613.69 ± 0.1% | not timed | not timed | 342369.87 ± 0.2% | 48.58 ± 0.3% | not timed | not timed | 21606.99 ± 0.1% | | 1.00 | 0.0631 | 444.88 |
| imported/rsc/medium-1mb | 27 | 21263.27 ± 1.0% | not timed | not timed | 11182478.25 ± 0.4% | 48.55 ± 0.1% | not timed | not timed | 21300.93 ± 2.3% | | 1.00 | 0.0019 | 437.96 |
| imported/rsc/hard-32 | 58 | 255.50 ± 2.4% | not timed | not timed | 366.98 ± 0.1% | 49.64 ± 8.9% | not timed | not timed | 255.01 ± 0.1% | | 1.00 | 0.70 | 5.15 |
| imported/rsc/hard-1k | 27 | 578.18 ± 0.2% | not timed | not timed | 11389.08 ± 0.2% | 40.78 ± 0.4% | not timed | not timed | 575.20 ± 0.2% | | 1.01 | 0.0508 | 14.18 |
| imported/rsc/hard-32k | 27 | 601.35 ± 0.4% | not timed | not timed | 359489.10 ± 0.6% | 29.36 ± 0.3% | not timed | not timed | 599.56 ± 0.2% | | 1.00 | 0.0017 | 20.48 |
| imported/rsc/hard-1mb | 51 | 603.84 ± 0.7% | not timed | not timed | 7250290.54 ± 0.1% | 29.40 ± 0.1% | not timed | not timed | 601.78 ± 0.8% | | 1.00 | 0.0001 | 20.54 |
| imported/rsc/reallyhard0-32 | 58 | 254.32 ± 2.6% | not timed | not timed | 223.22 ± 0.1% | 49.78 ± 8.3% | not timed | not timed | 254.46 ± 0.2% | | 1.00 | 1.14 | 5.11 |
| imported/rsc/reallyhard0-1k | 27 | 575.64 ± 0.6% | not timed | not timed | 582.77 ± 0.2% | 40.50 ± 11.1% | not timed | not timed | 578.09 ± 0.2% | | 1.00 | 0.99 | 14.21 |
| imported/rsc/reallyhard0-32k | 27 | 601.39 ± 0.3% | not timed | not timed | 618.03 ± 0.1% | 29.37 ± 0.1% | not timed | not timed | 604.00 ± 0.2% | | 1.00 | 0.97 | 20.47 |
| imported/rsc/reallyhard0-1mb | 51 | 592.22 ± 0.5% | not timed | not timed | 618.58 ± 0.1% | 29.35 ± 0.1% | not timed | not timed | 595.52 ± 0.2% | | 0.99 | 0.96 | 20.18 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.06 ± 0.1% | not timed | not timed | 196.23 ± 0.7% | 60.91 ± 12.3% | not timed | not timed | 273.68 ± 1.6% | | 1.00 | 1.40 | 4.50 |
| imported/rsc/reallyreallyhard0-1k | 16 | 856.84 ± 0.3% | not timed | not timed | 5933.51 ± 0.1% | 34.22 ± 4.1% | not timed | not timed | 856.41 ± 0.9% | | 1.00 | 0.14 | 25.04 |
| imported/rsc/reallyreallyhard0-32k | 16 | 621.08 ± 4.4% | not timed | not timed | 19348.16 ± 0.1% | 25.13 ± 4.4% | not timed | not timed | 623.94 ± 5.1% | | 1.00 | 0.0321 | 24.72 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 588.68 ± 0.6% | not timed | not timed | 20146.22 ± 1.8% | 24.86 ± 2.3% | not timed | not timed | 592.50 ± 0.6% | | 0.99 | 0.0292 | 23.68 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 267.02 ± 0.2% | not timed | not timed | 211.65 ± 0.4% | 55.77 ± 12.0% | not timed | not timed | 264.37 ± 3.1% | | 1.01 | 1.26 | 4.79 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 841.49 ± 0.9% | not timed | not timed | 6174.33 ± 0.1% | 34.37 ± 0.8% | not timed | not timed | 840.69 ± 0.8% | | 1.00 | 0.14 | 24.48 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 632.27 ± 4.2% | not timed | not timed | 19262.56 ± 0.1% | 24.96 ± 2.7% | not timed | not timed | 626.64 ± 6.1% | | 1.01 | 0.0328 | 25.33 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 589.91 ± 0.6% | not timed | not timed | 19792.26 ± 1.0% | 24.55 ± 2.4% | not timed | not timed | 588.68 ± 0.5% | | 1.00 | 0.0298 | 24.03 |
| imported/sherlock/name-sherlock | 776 | 19484.18 ± 2.5% | not timed | not timed | 18363.61 ± 0.8% | 10097.96 ± 27.0% | not timed | not timed | 19480.79 ± 2.0% | | 1.00 | 1.06 | 1.93 |
| imported/sherlock/name-holmes | 2766 | 14918.63 ± 5.2% | not timed | not timed | 15403.81 ± 0.7% | 3050.97 ± 25.6% | not timed | not timed | 15146.94 ± 2.1% | | 0.98 | 0.97 | 4.89 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19439.49 ± 1.7% | not timed | not timed | 18327.12 ± 0.4% | 8052.57 ± 33.4% | not timed | not timed | 19522.84 ± 0.6% | | 1.00 | 1.06 | 2.41 |
| imported/sherlock/name-sherlock-casei | 816 | 15480.09 ± 0.5% | not timed | not timed | 4012.92 ± 0.2% | 32.58 ± 0.2% | not timed | not timed | 15493.13 ± 0.7% | | 1.00 | 3.86 | 475.12 |
| imported/sherlock/name-holmes-casei | 2802 | 9411.58 ± 6.6% | not timed | not timed | 3299.89 ± 0.2% | 37.65 ± 3.2% | not timed | not timed | 9436.08 ± 2.4% | | 1.00 | 2.85 | 249.98 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12976.14 ± 3.9% | not timed | not timed | 3948.86 ± 0.1% | 32.53 ± 0.1% | not timed | not timed | 12990.18 ± 0.6% | | 1.00 | 3.29 | 398.90 |
| imported/sherlock/name-whitespace | 1461 | 14918.90 ± 5.4% | not timed | not timed | 14402.31 ± 0.4% | 7350.31 ± 36.9% | not timed | not timed | 14921.22 ± 0.2% | | 1.00 | 1.04 | 2.03 |
| imported/sherlock/name-alt1 | 1142 | 11453.20 ± 2.6% | not timed | not timed | 15839.11 ± 0.6% | 4132.09 ± 17.8% | not timed | not timed | 11480.24 ± 0.6% | | 1.00 | 0.72 | 2.77 |
| imported/sherlock/name-alt2 | 3542 | 8613.32 ± 0.5% | not timed | not timed | 3827.51 ± 0.1% | 31.36 ± 0.3% | not timed | not timed | 8634.50 ± 0.4% | | 1.00 | 2.25 | 274.65 |
| imported/sherlock/name-alt3 | 4507 | 5448.13 ± 0.5% | not timed | not timed | 3632.16 ± 0.1% | 9.93 ± 3.2% | not timed | not timed | 5458.89 ± 0.5% | | 1.00 | 1.50 | 548.63 |
| imported/sherlock/name-alt3-casei | 4593 | 1518.91 ± 2.1% | not timed | not timed | 285.84 ± 0.2% | 6.48 ± 0.1% | not timed | not timed | 1518.53 ± 1.1% | | 1.00 | 5.31 | 234.26 |
| imported/sherlock/name-alt4 | 3686 | 6188.84 ± 0.2% | not timed | not timed | 3790.27 ± 0.2% | 31.22 ± 0.0% | not timed | not timed | 6183.05 ± 0.2% | | 1.00 | 1.63 | 198.26 |
| imported/sherlock/name-alt4-casei | 4254 | 2770.96 ± 2.2% | not timed | not timed | 2597.21 ± 0.3% | 19.91 ± 0.4% | not timed | not timed | 2770.60 ± 1.3% | | 1.00 | 1.07 | 139.18 |
| imported/sherlock/name-alt5 | 4028 | 6221.44 ± 0.3% | not timed | not timed | 3746.07 ± 0.1% | 21.80 ± 0.2% | not timed | not timed | 6240.16 ± 0.3% | | 1.00 | 1.66 | 285.34 |
| imported/sherlock/name-alt5-casei | 4104 | 3463.83 ± 2.1% | not timed | not timed | 2229.79 ± 0.1% | 14.37 ± 0.2% | not timed | not timed | 3463.08 ± 1.5% | | 1.00 | 1.55 | 240.98 |
| imported/sherlock/no-match-uncommon | 0 | 21250.91 ± 2.0% | not timed | not timed | 19328.76 ± 0.8% | 34240.73 ± 0.2% | not timed | not timed | 21290.26 ± 3.9% | | 1.00 | 1.10 | 0.62 |
| imported/sherlock/no-match-common | 0 | 21036.72 ± 4.2% | not timed | not timed | 19281.18 ± 0.8% | 1281.06 ± 1.0% | not timed | not timed | 21087.33 ± 0.6% | | 1.00 | 1.09 | 16.42 |
| imported/sherlock/no-match-really-common | 0 | 16088.67 ± 4.0% | not timed | not timed | 18602.26 ± 0.9% | 1272.68 ± 1.1% | not timed | not timed | 16163.90 ± 1.8% | | 1.00 | 0.86 | 12.64 |
| imported/sherlock/the-lower | 21654 | 2301.79 ± 0.8% | not timed | not timed | 2328.00 ± 0.4% | 234.11 ± 14.3% | not timed | not timed | 2313.04 ± 2.0% | | 1.00 | 0.99 | 9.83 |
| imported/sherlock/the-upper | 2223 | 12604.89 ± 1.4% | not timed | not timed | 13491.34 ± 1.1% | 2703.86 ± 2.8% | not timed | not timed | 12684.65 ± 1.3% | | 0.99 | 0.93 | 4.66 |
| imported/sherlock/the-casei | 23961 | 2001.89 ± 1.3% | not timed | not timed | 1316.32 ± 0.5% | 34.41 ± 26.2% | not timed | not timed | 2002.03 ± 0.2% | | 1.00 | 1.52 | 58.17 |
| imported/sherlock/everything-greedy | 581881 | 271.08 ± 0.1% | not timed | not timed | 166.20 ± 0.2% | 29.01 ± 36.7% | not timed | not timed | 270.97 ± 0.6% | | 1.00 | 1.63 | 9.34 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.06 ± 0.2% | not timed | not timed | 212.45 ± 0.3% | 32.95 ± 0.2% | not timed | not timed | 463.25 ± 0.1% | | 1.00 | 2.17 | 14.03 |
| imported/sherlock/letters | 447175 | 54.37 ± 0.9% | not timed | not timed | 32.93 ± 0.3% | 6.20 ± 31.1% | not timed | not timed | 54.40 ± 0.3% | | 1.00 | 1.65 | 8.76 |
| imported/sherlock/letters-upper | 14180 | 433.68 ± 0.6% | not timed | not timed | 368.44 ± 0.1% | 28.91 ± 30.0% | not timed | not timed | 434.66 ± 0.9% | | 1.00 | 1.18 | 15.00 |
| imported/sherlock/letters-lower | 432995 | 55.49 ± 1.0% | not timed | not timed | 33.76 ± 0.3% | 7.81 ± 50.7% | not timed | not timed | 55.43 ± 1.0% | | 1.00 | 1.64 | 7.10 |
| imported/sherlock/words | 447639 | 106.78 ± 1.0% | not timed | not timed | 82.61 ± 0.2% | 13.58 ± 29.8% | not timed | not timed | 106.68 ± 0.4% | | 1.00 | 1.29 | 7.86 |
| imported/sherlock/before-holmes | 4073 | 599.44 ± 0.4% | not timed | not timed | 8430.52 ± 0.5% | 23.89 ± 1.6% | not timed | not timed | 597.09 ± 0.3% | | 1.00 | 0.0711 | 25.09 |
| imported/sherlock/before-after-holmes | 2593 | 597.33 ± 0.2% | not timed | not timed | 9160.76 ± 0.5% | 23.92 ± 0.6% | not timed | not timed | 597.70 ± 0.1% | | 1.00 | 0.0652 | 24.97 |
| imported/sherlock/holmes-cochar-watson | 150 | 5230.27 ± 0.4% | not timed | not timed | 3420.96 ± 0.2% | 30.95 ± 0.2% | not timed | not timed | 5232.24 ± 0.3% | | 1.00 | 1.53 | 168.97 |
| imported/sherlock/holmes-coword-watson | 14309 | 1262.82 ± 2.0% | not timed | not timed | 1120.83 ± 0.3% | 6.76 ± 0.2% | not timed | not timed | 1262.26 ± 0.5% | | 1.00 | 1.13 | 186.77 |
| imported/sherlock/quotes | 14437 | 1413.39 ± 0.2% | not timed | not timed | 1746.20 ± 1.1% | 35.17 ± 0.2% | not timed | not timed | 1413.16 ± 0.2% | | 1.00 | 0.81 | 40.19 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 602.31 ± 0.3% | not timed | not timed | 15868.22 ± 0.4% | 36.84 ± 0.1% | not timed | not timed | 602.08 ± 0.4% | | 1.00 | 0.0380 | 16.35 |
| imported/sherlock/word-ending-n | 35297 | 469.04 ± 1.0% | not timed | not timed | 409.32 ± 0.1% | 23.44 ± 17.3% | not timed | not timed | 468.36 ± 0.2% | | 1.00 | 1.15 | 20.01 |
| imported/sherlock/repeated-class-negation | 2130 | 14429.53 ± 1.1% | not timed | not timed | 10713.60 ± 0.5% | 11.59 ± 0.2% | not timed | not timed | 14423.21 ± 0.4% | | 1.00 | 1.35 | 1245.28 |
| imported/sherlock/ing-suffix | 20547 | 554.76 ± 0.3% | not timed | not timed | 517.56 ± 0.1% | 28.86 ± 0.2% | not timed | not timed | 554.62 ± 0.3% | | 1.00 | 1.07 | 19.22 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 595.32 ± 0.4% | not timed | not timed | 2097.73 ± 0.5% | 20.52 ± 0.3% | not timed | not timed | 595.21 ± 0.5% | | 1.00 | 0.28 | 29.01 |
| opt/accelerate/whole-line | 239963 | 458.58 ± 0.4% | not timed | not timed | 371.71 ± 0.3% | 91.88 ± 18.1% | not timed | not timed | 459.31 ± 0.1% | | 1.00 | 1.23 | 4.99 |
| opt/accelerate/non-dna | 16745 | 413.93 ± 0.7% | not timed | not timed | 399.19 ± 0.1% | 29.18 ± 61.5% | not timed | not timed | 413.82 ± 0.2% | | 1.00 | 1.04 | 14.18 |
| opt/backtrack/words-english | 40536 | 137.24 ± 1.8% | not timed | not timed | 94.48 ± 0.3% | 19.79 ± 7.9% | not timed | not timed | 134.56 ± 1.9% | | 1.02 | 1.45 | 6.93 |
| opt/fixed-length/too-small-ascii | 0 | 313.11 ± 0.2% | not timed | not timed | 678.32 ± 3.7% | 80.30 ± 1.3% | not timed | not timed | 311.82 ± 0.2% | | 1.00 | 0.46 | 3.90 |
| opt/fixed-length/too-big-ascii | 0 | 648.32 ± 0.9% | not timed | not timed | 5787.68 ± 0.2% | 126.98 ± 0.3% | not timed | not timed | 649.53 ± 0.7% | | 1.00 | 0.11 | 5.11 |
| opt/fixed-length/go33484-1 | 0 | 45.13 ± 0.1% | not timed | not timed | 1102406.80 ± 0.3% | 61265.69 ± 0.7% | not timed | not timed | 45.07 ± 0.0% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5526.58 ± 0.0% | not timed | not timed | 1102706.54 ± 0.2% | 32535.24 ± 1.3% | not timed | not timed | 5517.93 ± 0.1% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1765.51 ± 0.8% | not timed | not timed | 110720.34 ± 0.4% | 767.64 ± 0.1% | not timed | not timed | 1783.85 ± 0.3% | | 0.99 | 0.0159 | 2.30 |
| opt/literal-alt/one-pattern | 1 | 555.37 ± 10.5% | not timed | not timed | 535.99 ± 0.1% | 0.40 ± 1.7% | not timed | not timed | 555.97 ± 0.4% | | 1.00 | 1.04 | 1388.65 |
| opt/onepass/fn-predicate | 916 | 365.49 ± 0.4% | not timed | not timed | 333.06 ± 0.1% | 202.46 ± 13.6% | not timed | not timed | 367.85 ± 1.0% | | 0.99 | 1.10 | 1.81 |
| opt/onepass/first-three-words-english | 35128 | 148.15 ± 9.8% | not timed | not timed | 201.04 ± 0.1% | 81.90 ± 10.0% | not timed | not timed | 149.77 ± 7.4% | | 0.99 | 0.74 | 1.81 |
| opt/prefilter/literal-english | 1 | 20732.21 ± 0.3% | not timed | not timed | 19977.83 ± 0.2% | 17569.44 ± 0.4% | not timed | not timed | 20746.57 ± 0.1% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14465.95 ± 0.4% | not timed | not timed | 4318.17 ± 0.2% | 32.70 ± 0.2% | not timed | not timed | 14485.28 ± 0.4% | | 1.00 | 3.35 | 442.43 |
| opt/prefilter/literal-russian | 1 | 21242.55 ± 0.4% | not timed | not timed | 19820.44 ± 0.9% | 3330.03 ± 0.1% | not timed | not timed | 21231.81 ± 1.3% | | 1.00 | 1.07 | 6.38 |
| opt/prefilter/literal-casei-russian | 1 | 8542.22 ± 0.7% | not timed | not timed | 3895.48 ± 0.1% | 30.82 ± 0.3% | not timed | not timed | 8531.06 ± 0.0% | | 1.00 | 2.19 | 277.14 |
| opt/prefilter/rust-functions | 948 | 6816.95 ± 0.2% | not timed | not timed | 8951.93 ± 0.3% | 1871.29 ± 0.3% | not timed | not timed | 6816.39 ± 0.4% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 5590.14 ± 0.2% | not timed | not timed | 20798659.98 ± 0.1% | 50.00 ± 0.2% | not timed | not timed | 5595.88 ± 0.1% | | 1.00 | 0.0003 | 111.81 |
| opt/reverse-inner/holmes | 2593 | 597.14 ± 0.1% | not timed | not timed | 9425.18 ± 0.3% | 24.13 ± 1.0% | not timed | not timed | 598.07 ± 0.2% | | 1.00 | 0.0634 | 24.75 |
| opt/reverse-inner/email | 47 | 1045.35 ± 0.1% | not timed | not timed | 44702.37 ± 0.6% | 32.39 ± 0.4% | not timed | not timed | 1044.98 ± 0.1% | | 1.00 | 0.0234 | 32.27 |
| opt/reverse-inner/factored-prefix | 3542 | 592.15 ± 0.3% | not timed | not timed | 595.30 ± 0.0% | 12.54 ± 0.3% | not timed | not timed | 592.79 ± 0.2% | | 1.00 | 0.99 | 47.22 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5509.57 ± 0.1% | not timed | not timed | 613.27 ± 0.3% | 75.17 ± 0.2% | not timed | not timed | 5520.46 ± 0.0% | | 1.00 | 8.98 | 73.30 |
| opt/reverse-inner/no-quadratic-forward | 0 | 687.19 ± 2.3% | not timed | not timed | 288.49 ± 0.3% | 24.85 ± 0.1% | not timed | not timed | 690.29 ± 2.4% | | 1.00 | 2.38 | 27.65 |
| opt/reverse-suffix/holmes | 4073 | 598.89 ± 0.4% | not timed | not timed | 8400.92 ± 0.2% | 23.81 ± 0.9% | not timed | not timed | 597.19 ± 0.2% | | 1.00 | 0.0713 | 25.15 |
| opt/reverse-suffix/no-quadratic | 0 | 5518.82 ± 0.1% | not timed | not timed | 615.61 ± 0.5% | 75.00 ± 0.2% | not timed | not timed | 5508.52 ± 0.1% | | 1.00 | 8.96 | 73.58 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.36 ± 8.2% | not timed | not timed | 131.85 ± 0.6% | 13.48 ± 17.0% | not timed | not timed | 121.12 ± 3.1% | | 0.99 | 0.91 | 8.93 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.82 ± 1.5% | not timed | not timed | 133.33 ± 0.3% | 14.03 ± 13.3% | not timed | not timed | 120.85 ± 8.2% | | 1.00 | 0.91 | 8.61 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 3.1% | not timed | not timed | 0.55 ± 0.2% | 111.06 ± 7.2% | not timed | not timed | 0.28 ± 0.1% | | 1.00 | 0.52 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.73 ± 1.0% | not timed | not timed | 294.74 ± 0.0% | 103.35 ± 1.5% | not timed | not timed | 309.19 ± 0.2% | | 1.02 | 1.07 | 3.06 |
| reported/i13-subset-regex/original-ascii | 4094 | 11067.79 ± 0.8% | not timed | not timed | 4522.80 ± 0.3% | 11.50 ± 0.2% | not timed | not timed | 11115.90 ± 0.9% | | 1.00 | 2.45 | 962.07 |
| reported/i13-subset-regex/original-unicode | 4094 | 10975.23 ± 0.9% | not timed | not timed | 251.98 ± 3.3% | 11.51 ± 0.1% | not timed | not timed | 11098.09 ± 1.0% | | 0.99 | 43.56 | 953.30 |
| reported/i13-subset-regex/big-ascii | 1955 | 10680.00 ± 0.7% | not timed | not timed | 68.11 ± 3.6% | 9.86 ± 0.3% | not timed | not timed | 10733.61 ± 1.2% | | 1.00 | 156.81 | 1083.58 |
| reported/i13-subset-regex/big-unicode | 1955 | 10612.31 ± 2.3% | not timed | not timed | 12.24 ± 54.9% | 9.77 ± 1.3% | not timed | not timed | 10725.45 ± 0.9% | | 0.99 | 867.24 | 1086.17 |
| reported/i13-subset-regex/huge-ascii | 55 | 10135.75 ± 1.0% | not timed | not timed | 11.07 ± 0.1% | 8.77 ± 0.2% | not timed | not timed | 10113.55 ± 1.3% | | 1.00 | 915.31 | 1156.13 |
| reported/i13-subset-regex/huge-unicode | 55 | 10073.73 ± 3.2% | not timed | not timed | 10.97 ± 0.3% | 8.76 ± 0.1% | not timed | not timed | 9884.97 ± 3.1% | | 1.02 | 918.65 | 1149.33 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.09 ± 0.1% | 8.75 ± 1.3% | not timed | not timed | 3.55 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.1% | not timed | not timed | 11.00 ± 0.3% | 8.77 ± 0.0% | not timed | not timed | 5.03 ± 0.1% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 469.82 ± 0.2% | not timed | not timed | 104.76 ± 0.3% | 6.63 ± 0.1% | not timed | not timed | 469.31 ± 0.3% | | 1.00 | 4.48 | 70.88 |
| reported/i787-keywords/opt-ascii | 5674 | 470.92 ± 0.4% | not timed | not timed | 276.46 ± 0.2% | 10.27 ± 0.2% | not timed | not timed | 470.82 ± 0.2% | | 1.00 | 1.70 | 45.85 |
| slow/quadratic-regex-1x | 100 | 6.94 ± 0.2% | not timed | not timed | 4.96 ± 0.3% | 0.05 ± 0.3% | not timed | not timed | 6.96 ± 0.2% | | 1.00 | 1.40 | 140.86 |
| slow/quadratic-regex-2x | 199 | 3.40 ± 0.1% | not timed | not timed | 2.77 ± 0.1% | 0.01 ± 0.2% | not timed | not timed | 3.41 ± 0.1% | | 1.00 | 1.23 | 266.75 |
| slow/quadratic-haystack-1x | 100 | 21.09 ± 5.6% | not timed | not timed | 9.98 ± 0.1% | 1.02 ± 13.5% | not timed | not timed | 21.10 ± 1.9% | | 1.00 | 2.11 | 20.77 |
| slow/quadratic-haystack-2x | 200 | 17.54 ± 0.9% | not timed | not timed | 5.54 ± 0.1% | 0.54 ± 0.6% | not timed | not timed | 17.51 ± 12.9% | | 1.00 | 3.16 | 32.20 |
| unicode/codepoints/any-one | 1112064 | 286.65 ± 0.3% | not timed | not timed | 173.18 ± 0.3% | 18.33 ± 2.2% | not timed | not timed | 286.34 ± 0.2% | | 1.00 | 1.66 | 15.64 |
| unicode/codepoints/any-all | 4382592 | 290.48 ± 0.5% | not timed | not timed | 246.52 ± 0.2% | 117.46 ± 0.1% | not timed | not timed | 290.78 ± 1.2% | | 1.00 | 1.18 | 2.47 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.78 ± 1.0% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 611.06 ± 0.4% | not timed | not timed | 615.40 ± 0.3% | 134.99 ± 0.4% | not timed | not timed | 610.14 ± 0.2% | | 1.00 | 0.99 | 4.53 |
| unicode/overlapping-words/ascii | 6156 | 31.07 ± 0.3% | not timed | not timed | 38.97 ± 0.1% | 3.95 ± 0.5% | not timed | not timed | 31.20 ± 0.3% | | 1.00 | 0.80 | 7.88 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.1% | not timed | not timed | 3.24 ± 0.8% | 2.35 ± 0.6% | not timed | not timed | 1.36 ± 0.2% | | 1.00 | 0.42 | 0.57 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 9.6% | not timed | not timed | 3.07 ± 1.0% | 6.31 ± 7.9% | not timed | not timed | 1.22 ± 0.4% | | 1.00 | 0.40 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 117.18 ± 2.6% | not timed | not timed | 82.14 ± 0.2% | 11.46 ± 15.8% | not timed | not timed | 117.87 ± 0.5% | | 0.99 | 1.43 | 10.22 |
| unicode/word/boundary-long-english | 3466 | 606.29 ± 0.7% | not timed | not timed | 605.34 ± 0.2% | 32.62 ± 0.6% | not timed | not timed | 606.57 ± 0.1% | | 1.00 | 1.00 | 18.59 |
| unicode/word/around-holmes-english | 27 | 602.94 ± 0.1% | not timed | not timed | 19729.81 ± 0.7% | 22.29 ± 1.2% | not timed | not timed | 603.72 ± 0.5% | | 1.00 | 0.0306 | 27.05 |
| wild/bibleref/long | 874 | 565.40 ± 0.1% | not timed | not timed | 584.08 ± 0.1% | 6.55 ± 0.1% | not timed | not timed | 566.57 ± 0.1% | | 1.00 | 0.97 | 86.37 |
| wild/bibleref/short | 30 | 25.03 ± 2.9% | not timed | not timed | 31.45 ± 0.1% | 13.80 ± 10.9% | not timed | not timed | 25.85 ± 2.8% | | 0.97 | 0.80 | 1.81 |
| wild/bibleref/line | 874 | 357.46 ± 0.1% | not timed | not timed | 215.17 ± 0.1% | 9.21 ± 0.8% | not timed | not timed | 357.81 ± 0.3% | | 1.00 | 1.66 | 38.82 |
| wild/caddy/caddy | 6 | 411.24 ± 2.6% | not timed | not timed | 243.52 ± 0.1% | 65.93 ± 14.7% | not timed | not timed | 419.55 ± 2.2% | | 0.98 | 1.69 | 6.24 |
| wild/dot-star-capture/rust-src-tools | 6 | 1058.79 ± 0.4% | not timed | not timed | 350.50 ± 0.2% | 13.50 ± 0.1% | not timed | not timed | 1058.78 ± 0.2% | | 1.00 | 3.02 | 78.45 |
| wild/ruff/noqa | 84 | 404.26 ± 0.1% | not timed | not timed | 477.46 ± 0.2% | 19.57 ± 2.1% | not timed | not timed | 403.47 ± 2.5% | | 1.00 | 0.85 | 20.65 |
| wild/ruff/unnecessary-coding-comment | 16 | 488.70 ± 0.6% | not timed | not timed | 703.80 ± 0.2% | 136.50 ± 11.0% | not timed | not timed | 489.78 ± 0.7% | | 1.00 | 0.69 | 3.58 |
| wild/ruff/string-quote-prefix | 2972 | 407.31 ± 0.5% | not timed | not timed | 443.45 ± 0.2% | 317.20 ± 25.5% | not timed | not timed | 407.12 ± 0.5% | | 1.00 | 0.92 | 1.28 |
| wild/ruff/space-around-operator | 1224378 | 217.18 ± 1.8% | not timed | not timed | 187.89 ± 0.1% | 18.47 ± 1.7% | not timed | not timed | 217.31 ± 1.8% | | 1.00 | 1.16 | 11.76 |
| wild/ruff/shebang | 282 | 401.74 ± 0.6% | not timed | not timed | 328.59 ± 0.1% | 118.46 ± 15.9% | not timed | not timed | 401.35 ± 0.4% | | 1.00 | 1.22 | 3.39 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13837.94 ± 0.3% | not timed | not timed | 13867.52 ± 0.6% | 6904.64 ± 0.6% | not timed | not timed | 13855.19 ± 0.1% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12829.62 ± 0.5% | not timed | not timed | 13471.08 ± 5.4% | 6387.41 ± 10.3% | not timed | not timed | 12823.91 ± 0.3% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13206.21 ± 0.7% | not timed | not timed | 13668.49 ± 0.4% | 6629.60 ± 1.2% | not timed | not timed | 13241.65 ± 0.3% | | 1.00 | 0.97 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9555.77 ± 0.3% | not timed | not timed | 13558.98 ± 0.3% | 6750.34 ± 1.0% | not timed | not timed | 9572.31 ± 0.3% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 122.36 ± 13.9% | not timed | not timed | 65.62 ± 0.8% | 2.22 ± 0.7% | not timed | not timed | 121.61 ± 13.5% | | 1.01 | 1.86 | 55.09 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 64.5% | not timed | not timed | 0.01 ± 1.9% | 0.01 ± 20.4% | not timed | not timed | 0.03 ± 3.6% | | 1.00 | 3.12 | 3.87 |
| dictionary/compile/english-15 | 1 | 0.35 ± 20.7% | not timed | not timed | 0.07 ± 0.8% | 0.10 ± 12.2% | not timed | not timed | 0.35 ± 0.4% | | 1.00 | 5.08 | 3.49 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 5.3% | not timed | not timed | 0.02 ± 1.4% | 35.14 ± 10.4% | not timed | not timed | 0.25 ± 3.0% | | 0.96 | 12.78 | 0.0069 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.32 ± 4.8% | not timed | not timed | 11.46 ± 0.5% | 54.14 ± 19.0% | not timed | not timed | 47.78 ± 2.1% | | 0.99 | 4.13 | 0.87 |
| reported/i787-keywords/compile | 1 | 35.61 ± 14.1% | not timed | not timed | 2.12 ± 1.1% | 17.22 ± 28.1% | not timed | not timed | 35.57 ± 2.4% | | 1.00 | 16.82 | 2.07 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 368.67 ± 5.2% | not timed | not timed | 118.85 ± 0.3% | 576.19 ± 31.3% | not timed | not timed | 377.02 ± 4.6% | | 0.98 | 3.10 | 0.64 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 48.07 ± 1.8% | not timed | not timed | 4.09 ± 0.9% | 43.46 ± 2.0% | not timed | not timed | 48.96 ± 1.7% | | 0.98 | 11.76 | 1.11 |
| unicode/compile/one-letter | 53 | 6.80 ± 3.5% | not timed | not timed | 4.57 ± 0.7% | 66.08 ± 7.1% | not timed | not timed | 6.81 ± 12.3% | | 1.00 | 1.49 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.07 ± 16.0% | not timed | not timed | 0.10 ± 0.4% | 65.98 ± 3.3% | not timed | not timed | 1.10 ± 15.8% | | 0.97 | 10.88 | 0.0163 |
| unicode/compile/fifty-letters-ascii | 1 | 224.01 ± 13.1% | not timed | not timed | 52.25 ± 0.1% | 193.69 ± 16.6% | not timed | not timed | 226.40 ± 9.1% | | 0.99 | 4.29 | 1.16 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 391.86 ± 26.0% | not timed | not timed | 46.84 ± 0.7% | 687.63 ± 17.5% | not timed | not timed | 396.21 ± 9.2% | | 0.99 | 8.37 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 609.37 ± 7.6% | not timed | not timed | 145.80 ± 0.2% | 661.57 ± 27.8% | not timed | not timed | 633.10 ± 1.5% | | 0.96 | 4.18 | 0.92 |
| unicode/compile/negated-class-matches-codepoint | 1 | 332.15 ± 14.3% | not timed | not timed | 51.67 ± 0.3% | 1274.88 ± 27.2% | not timed | not timed | 336.64 ± 1.5% | | 0.99 | 6.43 | 0.26 |
| wild/bibleref/compile | 3 | 5.83 ± 4.6% | not timed | not timed | 1.93 ± 1.0% | 32.09 ± 36.4% | not timed | not timed | 5.98 ± 24.7% | | 0.97 | 3.03 | 0.18 |
| wild/url/compile | 1 | 0.57 ± 17.8% | not timed | not timed | 0.14 ± 0.4% | 0.45 ± 7.8% | not timed | not timed | 0.66 ± 20.2% | | 0.86 | 3.93 | 1.25 |

