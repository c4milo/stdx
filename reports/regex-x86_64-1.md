# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
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
| literal: a word | 217 | 25727.64 ± 0.9% | 9619.71 ± 0.3% | 25.99 ± 1.3% | 24653.56 ± 0.6% | 9307.32 ± 6.0% | 12.11 ± 1.1% | 85.12 ± 2.2% | 25789.80 ± 5.8% | 2.67 | 1.00 | 1.04 | 2.76 |
| literal: a word that is not there | 0 | 30917.14 ± 0.3% | 8549.26 ± 0.9% | 25.64 ± 2.0% | 27131.21 ± 0.6% | 30208.85 ± 2.2% | 11.79 ± 1.0% | 80.24 ± 2.4% | 30909.06 ± 13.2% | 3.62 | 1.00 | 1.14 | 1.02 |
| literal: one of four words | 661 | 10715.45 ± 3.9% | 1431.03 ± 0.6% | 14.71 ± 1.2% | 7802.51 ± 0.8% | 23.25 ± 1.8% | 3.53 ± 0.4% | 6.04 ± 0.5% | 10771.66 ± 3.4% | 7.49 | 0.99 | 1.37 | 460.88 |
| literal: a word in any case | 217 | 22541.12 ± 3.8% | 1541.99 ± 0.2% | 19.60 ± 10.2% | 8008.41 ± 4.2% | 43.86 ± 4.7% | refused | differs | 22507.15 ± 1.8% | 14.62 | 1.00 | 2.81 | 513.99 |
| literal: an href attribute | 33 | 23208.92 ± 0.3% | 516.94 ± 0.3% | 23.95 ± 1.5% | 22243.44 ± 0.9% | 2083.83 ± 1.0% | 8.64 ± 0.3% | 70.17 ± 1.0% | 23242.84 ± 0.8% | 44.90 | 1.00 | 1.04 | 11.14 |
| literal: a word, second text | 123 | 27168.28 ± 0.3% | 3834.65 ± 0.6% | 25.82 ± 1.5% | 24549.94 ± 1.2% | 7268.98 ± 3.1% | 15.78 ± 0.4% | 73.19 ± 1.1% | 27227.37 ± 0.3% | 7.08 | 1.00 | 1.11 | 3.74 |
| class: two capitalized words | 1331 | 876.11 ± 0.2% | 512.39 ± 0.1% | 25.29 ± 1.3% | 487.79 ± 0.4% | 38.86 ± 5.9% | 10.27 ± 0.3% | 62.55 ± 0.2% | 876.60 ± 2.2% | 1.71 | 1.00 | 1.80 | 22.54 |
| class: a word that ends in ing | 3399 | 490.05 ± 0.4% | 489.45 ± 0.7% | 16.64 ± 0.6% | 459.15 ± 0.3% | 28.12 ± 2.4% | 5.76 ± 0.1% | 17.06 ± 0.6% | 490.46 ± 0.7% | 1.00 | 1.00 | 1.07 | 17.43 |
| class: a word in capitals | 2332 | 1273.49 ± 5.4% | 519.50 ± 10.4% | 26.60 ± 3.7% | 481.28 ± 0.3% | 42.11 ± 11.4% | 12.33 ± 0.3% | 79.88 ± 2.8% | 1275.43 ± 1.5% | 2.45 | 1.00 | 2.65 | 30.24 |
| class: a number | 8288 | 2529.47 ± 0.4% | 720.15 ± 1.3% | 26.35 ± 2.2% | 1674.95 ± 1.0% | 41.36 ± 12.6% | 0.34 ± 1.4% | 57.91 ± 0.8% | 2534.90 ± 0.3% | 3.51 | 1.00 | 1.51 | 61.16 |
| class: two capitalized words, second text | 5359 | 432.70 ± 0.1% | 439.69 ± 1.0% | 22.68 ± 1.7% | 405.24 ± 0.3% | 33.43 ± 9.4% | 13.42 ± 0.3% | 56.93 ± 0.2% | 433.79 ± 0.4% | 0.98 | 1.00 | 1.07 | 12.94 |
| other: a word between two words | 6104 | 722.53 ± 0.3% | 510.04 ± 5.1% | 22.44 ± 12.2% | 691.24 ± 0.7% | 108.22 ± 14.4% | 7.84 ± 0.1% | 62.69 ± 1.7% | 722.27 ± 0.5% | 1.42 | 1.00 | 1.05 | 6.68 |
| other: a number before a unit, second text | 1481 | 7318.44 ± 7.3% | 944.44 ± 2.1% | 25.38 ± 1.7% | 7317.57 ± 0.5% | 39.72 ± 0.7% | 14.03 ± 0.2% | 60.84 ± 0.6% | 7363.36 ± 5.8% | 7.75 | 0.99 | 1.00 | 184.26 |
| other: a heading's start tag | 110 | 16519.31 ± 0.4% | 627.56 ± 0.3% | 25.63 ± 1.0% | 2109.41 ± 1.2% | 1539.73 ± 3.8% | 10.74 ± 0.8% | 89.20 ± 1.8% | 16531.08 ± 1.7% | 26.32 | 1.00 | 7.83 | 10.73 |
| other: a whole word | 217 | 20735.67 ± 3.8% | 510.71 ± 0.7% | 26.18 ± 2.0% | 19723.30 ± 0.5% | 46.14 ± 0.9% | 10.24 ± 0.3% | 48.85 ± 1.5% | 20806.43 ± 0.3% | 40.60 | 1.00 | 1.05 | 449.44 |
| other: a line's first word, second text | 3716 | 1854.94 ± 1.0% | 502.04 ± 0.9% | 28.04 ± 1.5% | 1957.20 ± 1.1% | 63.46 ± 7.8% | refused | refused | 1861.07 ± 0.5% | 3.69 | 1.00 | 0.95 | 29.23 |
| other: fourteen octets before an x | 87 | 27300.04 ± 1.7% | 242.03 ± 0.6% | 6.31 ± 0.3% | 3373.41 ± 0.9% | 9.14 ± 0.8% | differs | 15.72 ± 1.3% | 27422.59 ± 1.5% | 112.80 | 1.00 | 8.09 | 2985.62 |
| other: a Greek word | 21815 | 499.23 ± 1.4% | 384.08 ± 0.3% | 29.41 ± 2.4% | 250.15 ± 0.4% | 44.90 ± 11.1% | differs | refused | 499.68 ± 2.3% | 1.30 | 1.00 | 2.00 | 11.12 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.60 ± 0.5% | 24.59 ± 0.9% | 0.85 ± 1.9% | 16.97 ± 0.2% | 2.48 ± 0.8% | differs | 3.71 ± 0.6% | 24.52 ± 0.4% | 1.00 | 1.00 | 1.45 | 9.93 |
| a UUID | 32895 | 23.09 ± 0.9% | 23.16 ± 0.8% | 0.59 ± 3.3% | 13.08 ± 0.4% | 2.56 ± 5.6% | 0.57 ± 0.2% | 3.19 ± 2.7% | 23.17 ± 0.5% | 1.00 | 1.00 | 1.77 | 9.01 |
| an IPv4 address | 33176 | 30.85 ± 2.8% | 30.92 ± 0.6% | 1.91 ± 0.7% | 24.81 ± 0.4% | 6.03 ± 2.7% | differs | 3.52 ± 2.2% | 30.80 ± 1.6% | 1.00 | 1.00 | 1.24 | 5.11 |
| a date and time | 32954 | 30.62 ± 1.7% | 30.55 ± 1.6% | 1.37 ± 1.5% | 18.94 ± 0.3% | 7.86 ± 0.9% | 1.03 ± 1.6% | 6.84 ± 0.9% | 30.59 ± 0.5% | 1.00 | 1.00 | 1.62 | 3.90 |
| a field path | 32606 | 26.24 ± 9.1% | 26.25 ± 0.2% | 1.00 ± 1.6% | 19.50 ± 0.2% | 2.82 ± 0.4% | differs | 2.39 ± 6.7% | 26.23 ± 0.7% | 1.00 | 1.00 | 1.35 | 9.30 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.49 ± 8.8% | 9.52 ± 19.5% | 9.51 ± 1.7% | 11.92 ± 1.6% | 5.11 ± 1.8% | 0.81 ± 3.7% | none | 9.51 ± 2.8% | 1.00 | 1.00 | 0.80 | 1.86 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 227.86 ± 4.8% | 228.30 ± 0.5% | 270.49 ± 0.6% | 87.89 ± 1.9% | 199.45 ± 10.6% | 544.06 ± 1.8% | 3276.17 ± 2.8% | 227.86 ± 1.3% | 1.00 | 1.00 | 2.59 | 1.14 |
| a UUID | 62 | 152.69 ± 0.3% | 152.82 ± 0.3% | 171.58 ± 0.6% | 46.20 ± 1.5% | 91.93 ± 0.4% | 195.55 ± 2.0% | 4077.71 ± 0.8% | 152.65 ± 0.9% | 1.00 | 1.00 | 3.31 | 1.66 |
| an IPv4 address | 29 | 441.13 ± 0.3% | 441.71 ± 0.5% | 627.04 ± 0.4% | 76.66 ± 0.7% | 121.77 ± 1.9% | 343.94 ± 2.2% | 6587.29 ± 1.9% | 441.88 ± 1.3% | 1.00 | 1.00 | 5.75 | 3.62 |
| a date and time | 56 | 335.83 ± 0.4% | 336.56 ± 0.2% | 430.51 ± 0.5% | 73.69 ± 1.7% | 127.75 ± 1.5% | 360.14 ± 2.8% | 4252.19 ± 4.0% | 336.32 ± 8.2% | 1.00 | 1.00 | 4.56 | 2.63 |
| a field path | 39 | 226.31 ± 4.5% | 226.29 ± 2.5% | 266.43 ± 0.4% | 81.16 ± 2.3% | 190.89 ± 1.2% | 567.05 ± 1.1% | 4153.09 ± 1.3% | 226.74 ± 0.3% | 1.00 | 1.00 | 2.79 | 1.19 |
| literal: a word | 7 | 650.71 ± 0.8% | 694.09 ± 2.2% | 1270.98 ± 0.5% | 519.79 ± 0.8% | 619.84 ± 4.6% | 1184.44 ± 0.8% | 26885.85 ± 0.5% | 650.85 ± 0.4% | 0.94 | 1.00 | 1.25 | 1.05 |
| literal: a word that is not there | 8 | 623.16 ± 0.6% | 672.43 ± 0.3% | 1196.50 ± 0.4% | 483.71 ± 0.3% | 596.95 ± 3.6% | 1113.44 ± 3.0% | 25458.28 ± 0.9% | 624.91 ± 0.3% | 0.93 | 1.00 | 1.29 | 1.04 |
| literal: one of four words | 26 | 256.29 ± 1.0% | 417.05 ± 0.3% | 577.31 ± 0.7% | 38.99 ± 1.2% | 228.75 ± 4.1% | 408.46 ± 2.2% | 12780.52 ± 0.3% | 256.19 ± 0.4% | 0.61 | 1.00 | 6.57 | 1.12 |
| literal: a word in any case | 11 | 461.54 ± 0.4% | 493.32 ± 0.5% | 727.62 ± 0.2% | 13.34 ± 1.1% | 638.38 ± 18.3% | refused | 20080.32 ± 1.2% | 460.86 ± 0.6% | 0.94 | 1.00 | 34.61 | 0.72 |
| literal: an href attribute | 12 | 349.68 ± 11.6% | 362.08 ± 0.7% | 481.37 ± 0.6% | 38.77 ± 0.3% | 476.90 ± 2.6% | 929.36 ± 0.9% | 18396.85 ± 2.7% | 350.83 ± 0.6% | 0.97 | 1.00 | 9.02 | 0.73 |
| literal: a word, second text | 10 | 576.64 ± 0.9% | 630.69 ± 0.9% | 1070.30 ± 6.5% | 429.67 ± 11.1% | 488.82 ± 18.3% | 952.27 ± 4.5% | 23150.06 ± 3.6% | 576.27 ± 2.5% | 0.91 | 1.00 | 1.34 | 1.18 |
| class: two capitalized words | 23 | 487.93 ± 0.6% | 524.81 ± 2.2% | 788.14 ± 0.8% | 103.99 ± 1.3% | 474.11 ± 13.0% | 865.71 ± 1.7% | 5768.45 ± 3.2% | 486.13 ± 1.1% | 0.93 | 1.00 | 4.69 | 1.03 |
| class: a word that ends in ing | 9 | 559.99 ± 1.3% | 650.98 ± 3.7% | 1163.48 ± 1.4% | 134.93 ± 0.4% | 710.45 ± 1.4% | 1339.64 ± 0.9% | 14426.07 ± 0.4% | 565.57 ± 1.0% | 0.86 | 0.99 | 4.15 | 0.79 |
| class: a word in capitals | 16 | 520.12 ± 0.4% | 561.87 ± 0.3% | 949.93 ± 0.6% | 138.88 ± 1.2% | 714.93 ± 2.7% | 1244.61 ± 1.3% | 7748.85 ± 0.8% | 521.02 ± 0.3% | 0.93 | 1.00 | 3.75 | 0.73 |
| class: a number | 6 | 634.45 ± 0.5% | 695.09 ± 21.8% | 1359.48 ± 0.3% | 34.51 ± 2.5% | 1289.56 ± 2.7% | 2365.01 ± 7.3% | 21183.67 ± 2.3% | 634.38 ± 9.4% | 0.91 | 1.00 | 18.39 | 0.49 |
| class: two capitalized words, second text | 23 | 488.40 ± 0.6% | 523.11 ± 0.6% | 787.16 ± 0.7% | 104.08 ± 4.4% | 481.91 ± 2.0% | 893.10 ± 0.8% | 5761.22 ± 3.4% | 488.29 ± 12.2% | 0.93 | 1.00 | 4.69 | 1.01 |
| other: a word between two words | 13 | 563.96 ± 0.3% | 583.63 ± 1.5% | 940.26 ± 5.2% | 138.47 ± 6.0% | 476.61 ± 19.1% | 970.16 ± 0.2% | 12685.30 ± 0.7% | 553.01 ± 8.4% | 0.97 | 1.02 | 4.07 | 1.18 |
| other: a number before a unit, second text | 15 | 407.27 ± 9.3% | 459.14 ± 0.8% | 645.20 ± 1.9% | 32.79 ± 2.5% | 593.71 ± 2.3% | 1100.80 ± 0.4% | 13197.14 ± 5.9% | 409.93 ± 26.1% | 0.89 | 0.99 | 12.42 | 0.69 |
| other: a heading's start tag | 13 | 360.61 ± 1.1% | 370.88 ± 1.9% | 490.99 ± 3.0% | 37.88 ± 2.1% | 577.14 ± 7.8% | 1038.03 ± 1.2% | 15432.62 ± 2.6% | 361.80 ± 0.3% | 0.97 | 1.00 | 9.52 | 0.62 |
| other: a whole word | 11 | 589.65 ± 0.9% | 622.58 ± 1.0% | 1041.63 ± 1.0% | 118.32 ± 6.2% | 540.37 ± 13.9% | 1002.13 ± 1.5% | 21979.75 ± 1.3% | 589.81 ± 0.5% | 0.95 | 1.00 | 4.98 | 1.09 |
| other: a line's first word, second text | 17 | 542.88 ± 5.2% | 584.99 ± 1.0% | 975.22 ± 0.4% | 133.81 ± 0.6% | 652.67 ± 25.6% | refused | refused | 546.66 ± 2.5% | 0.93 | 0.99 | 4.06 | 0.83 |
| other: fourteen octets before an x | 16 | 103.22 ± 0.5% | 147.68 ± 0.4% | 175.11 ± 1.1% | 14.66 ± 0.5% | 421.63 ± 1.2% | 462.22 ± 3.5% | 11584.34 ± 1.5% | 103.45 ± 0.8% | 0.70 | 1.00 | 7.04 | 0.24 |
| other: a Greek word | 8 | 423.24 ± 1.1% | 598.98 ± 0.7% | 1028.26 ± 0.3% | 48.58 ± 0.4% | 1289.90 ± 3.8% | 2274.32 ± 0.9% | refused | 424.50 ± 0.1% | 0.71 | 1.00 | 8.71 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20848.86 ± 2.0% | not timed | not timed | 21648.18 ± 0.7% | 1980.24 ± 14.1% | not timed | not timed | 20883.36 ± 0.6% | | 1.00 | 0.96 | 10.53 |
| 01-literal/sherlock-casei-en | 522 | 17758.76 ± 2.9% | not timed | not timed | 6728.18 ± 1.2% | 30.07 ± 1.1% | not timed | not timed | 17813.11 ± 1.3% | | 1.00 | 2.64 | 590.64 |
| 01-literal/sherlock-ru | 724 | 21400.42 ± 1.8% | not timed | not timed | 21943.94 ± 0.8% | 1133.09 ± 3.2% | not timed | not timed | 21444.68 ± 1.3% | | 1.00 | 0.98 | 18.89 |
| 01-literal/sherlock-casei-ru | 746 | 9178.22 ± 1.7% | not timed | not timed | 5347.24 ± 2.0% | 32.97 ± 1.6% | not timed | not timed | 9189.60 ± 0.7% | | 1.00 | 1.72 | 278.36 |
| 01-literal/sherlock-zh | 30 | 28934.68 ± 9.5% | not timed | not timed | 26015.13 ± 18.9% | 1264.97 ± 2.0% | not timed | not timed | 28966.29 ± 0.3% | | 1.00 | 1.11 | 22.87 |
| 02-literal-alternate/sherlock-en | 714 | 10028.59 ± 1.2% | not timed | not timed | 7460.69 ± 2.6% | 17.85 ± 1.1% | not timed | not timed | 10047.98 ± 1.8% | | 1.00 | 1.34 | 561.77 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1812.16 ± 1.2% | not timed | not timed | 1919.35 ± 1.8% | 10.37 ± 3.3% | not timed | not timed | 1812.20 ± 1.5% | | 1.00 | 0.94 | 174.67 |
| 02-literal-alternate/sherlock-ru | 899 | 7909.77 ± 0.7% | not timed | not timed | 4077.00 ± 0.8% | 23.04 ± 0.2% | not timed | not timed | 7905.87 ± 0.8% | | 1.00 | 1.94 | 343.37 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1886.23 ± 1.7% | not timed | not timed | 986.21 ± 1.0% | 8.84 ± 0.7% | not timed | not timed | 1899.48 ± 0.8% | | 0.99 | 1.91 | 213.42 |
| 02-literal-alternate/sherlock-zh | 207 | 13528.53 ± 4.5% | not timed | not timed | 8553.00 ± 1.0% | 33.01 ± 4.3% | not timed | not timed | 13521.79 ± 1.4% | | 1.00 | 1.58 | 409.88 |
| 03-date/ascii | 111817 | 119.30 ± 0.8% | not timed | not timed | 87.94 ± 2.0% | 0.20 ± 3.0% | not timed | not timed | 119.46 ± 0.5% | | 1.00 | 1.36 | 608.23 |
| 04-ruff-noqa/real | 84 | 488.48 ± 0.4% | not timed | not timed | 450.16 ± 0.9% | 19.04 ± 0.8% | not timed | not timed | 488.87 ± 0.5% | | 1.00 | 1.09 | 25.65 |
| 04-ruff-noqa/tweaked | 44 | 787.26 ± 0.4% | not timed | not timed | 451.29 ± 0.4% | 318.22 ± 1.9% | not timed | not timed | 784.77 ± 0.3% | | 1.00 | 1.74 | 2.47 |
| 05-lexer-veryl/single | 124800 | 4.28 ± 4.5% | not timed | not timed | 4.73 ± 10.7% | 0.21 ± 3.4% | not timed | not timed | 4.26 ± 9.7% | | 1.00 | 0.90 | 20.78 |
| 06-cloud-flare-redos/original | 107 | 406.32 ± 0.2% | not timed | not timed | 200.27 ± 1.2% | 24.09 ± 1.1% | not timed | not timed | 406.18 ± 0.5% | | 1.00 | 2.03 | 16.87 |
| 06-cloud-flare-redos/simplified-short | 102 | 395.75 ± 2.9% | not timed | not timed | 179.00 ± 2.9% | 25.52 ± 4.7% | not timed | not timed | 394.94 ± 2.2% | | 1.00 | 2.21 | 15.51 |
| 06-cloud-flare-redos/simplified-long | 10000 | 488.33 ± 0.2% | not timed | not timed | 216.76 ± 1.3% | 28.23 ± 0.5% | not timed | not timed | 488.74 ± 0.3% | | 1.00 | 2.25 | 17.30 |
| 07-unicode-character-data/parse-line | 558784 | 225.08 ± 3.5% | not timed | not timed | 166.84 ± 0.4% | 37.67 ± 7.6% | not timed | not timed | 222.76 ± 4.2% | | 1.01 | 1.35 | 5.98 |
| 08-words/all-english | 56691 | 109.88 ± 0.7% | not timed | not timed | 74.18 ± 0.7% | 11.54 ± 9.3% | not timed | not timed | 109.93 ± 0.9% | | 1.00 | 1.48 | 9.52 |
| 08-words/long-english | 839 | 521.00 ± 0.4% | not timed | not timed | 495.94 ± 0.8% | 29.47 ± 5.8% | not timed | not timed | 521.64 ± 0.4% | | 1.00 | 1.05 | 17.68 |
| 09-aws-keys/full | 0 | 507.21 ± 2.2% | not timed | not timed | 454.99 ± 0.5% | 60.40 ± 4.3% | not timed | not timed | 507.86 ± 1.0% | | 1.00 | 1.11 | 8.40 |
| 09-aws-keys/quick | 0 | 958.27 ± 1.7% | not timed | not timed | 748.56 ± 0.4% | 361.46 ± 13.9% | not timed | not timed | 960.05 ± 0.4% | | 1.00 | 1.28 | 2.65 |
| 10-bounded-repeat/letters-en | 1833 | 526.76 ± 2.8% | not timed | not timed | 453.76 ± 2.4% | 19.10 ± 6.7% | not timed | not timed | 525.59 ± 7.8% | | 1.00 | 1.16 | 27.58 |
| 10-bounded-repeat/letters-ru | 3475 | 439.20 ± 21.9% | not timed | not timed | 406.29 ± 0.4% | 20.50 ± 27.0% | not timed | not timed | 440.24 ± 6.0% | | 1.00 | 1.08 | 21.42 |
| 10-bounded-repeat/context | 53 | 75.77 ± 7.7% | not timed | not timed | 59.90 ± 0.4% | 19.05 ± 3.2% | not timed | not timed | 75.77 ± 2.0% | | 1.00 | 1.27 | 3.98 |
| 10-bounded-repeat/capitals | 11 | 534.93 ± 8.2% | not timed | not timed | 510.26 ± 2.6% | 35.43 ± 5.8% | not timed | not timed | 534.85 ± 7.6% | | 1.00 | 1.05 | 15.10 |
| 11-unstructured-to-json/extract | 600 | 42.80 ± 1.9% | not timed | not timed | 64.08 ± 2.0% | 48.67 ± 1.6% | not timed | not timed | 42.54 ± 1.6% | | 1.01 | 0.67 | 0.88 |
| 12-dictionary/single | 1 | 454.60 ± 1.5% | not timed | not timed | 435.23 ± 2.0% | 0.37 ± 1.5% | not timed | not timed | 456.90 ± 1.9% | | 0.99 | 1.04 | 1232.18 |
| 14-quadratic/1x | 100 | 22.94 ± 10.0% | not timed | not timed | 10.94 ± 1.5% | 0.96 ± 10.3% | not timed | not timed | 23.13 ± 4.0% | | 0.99 | 2.10 | 24.01 |
| 14-quadratic/2x | 200 | 21.40 ± 1.0% | not timed | not timed | 5.32 ± 0.2% | 0.53 ± 2.2% | not timed | not timed | 21.37 ± 3.0% | | 1.00 | 4.02 | 40.21 |
| 14-quadratic/10x | 1000 | 11.26 ± 5.8% | not timed | not timed | 1.03 ± 0.8% | 0.12 ± 4.8% | not timed | not timed | 11.46 ± 4.7% | | 0.98 | 10.93 | 95.16 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.20 ± 6.3% | not timed | not timed | 0.34 ± 1.0% | 0.52 ± 4.0% | not timed | not timed | 1.20 ± 4.9% | | 1.00 | 3.53 | 2.31 |
| 04-ruff-noqa/compile-real | 1 | 120.82 ± 1.1% | not timed | not timed | 12.25 ± 1.2% | 133.38 ± 10.7% | not timed | not timed | 121.50 ± 6.9% | | 0.99 | 9.86 | 0.91 |
| 05-lexer-veryl/compile-single | 1 | 14.93 ± 4.0% | not timed | not timed | 2.30 ± 0.8% | 6.14 ± 3.2% | not timed | not timed | 14.99 ± 2.2% | | 1.00 | 6.49 | 2.43 |
| 07-unicode-character-data/compile | 1 | 121.82 ± 3.5% | not timed | not timed | 25.00 ± 0.6% | 33.66 ± 2.9% | not timed | not timed | 121.98 ± 1.6% | | 1.00 | 4.87 | 3.62 |
| 09-aws-keys/compile-full | 1 | 49.54 ± 4.6% | not timed | not timed | 6.97 ± 0.9% | 21.45 ± 20.5% | not timed | not timed | 49.68 ± 5.5% | | 1.00 | 7.11 | 2.31 |
| 09-aws-keys/compile-quick | 1 | 184.57 ± 0.5% | not timed | not timed | 46.72 ± 0.2% | 127.59 ± 3.5% | not timed | not timed | 185.53 ± 0.5% | | 0.99 | 3.95 | 1.45 |
| 10-bounded-repeat/compile-context | 1 | 51.87 ± 6.1% | not timed | not timed | 11.00 ± 1.9% | 16.01 ± 13.9% | not timed | not timed | 51.62 ± 3.3% | | 1.00 | 4.72 | 3.24 |
| 10-bounded-repeat/compile-capitals | 1 | 72.91 ± 1.9% | not timed | not timed | 8.20 ± 0.6% | 23.28 ± 3.8% | not timed | not timed | 73.13 ± 2.5% | | 1.00 | 8.89 | 3.13 |
| 11-unstructured-to-json/compile | 1 | 183.82 ± 3.5% | not timed | not timed | 38.29 ± 8.4% | 63.99 ± 2.3% | not timed | not timed | 184.00 ± 3.2% | | 1.00 | 4.80 | 2.87 |
| 12-dictionary/compile-single | 1 | 0.29 ± 6.9% | not timed | not timed | 0.06 ± 1.1% | 0.09 ± 3.1% | not timed | not timed | 0.29 ± 1.1% | | 1.00 | 4.61 | 3.08 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 6.20 ± 1.1% | not timed | not timed | 6.23 ± 0.5% | 0.62 ± 26.7% | not timed | not timed | 6.20 ± 2.1% | | 1.00 | 0.99 | 9.99 |
| dictionary/search/english-10 | 690 | 151.05 ± 4.0% | not timed | not timed | 98.84 ± 2.1% | 0.01 ± 0.6% | not timed | not timed | 150.65 ± 3.2% | | 1.00 | 1.53 | 24952.82 |
| dictionary/search/english-15 | 15 | 453.55 ± 14.8% | not timed | not timed | 436.11 ± 0.2% | 0.35 ± 3.3% | not timed | not timed | 457.62 ± 1.6% | | 0.99 | 1.04 | 1288.64 |
| folly/awyer-inn-busted | 1 | 18158.56 ± 0.4% | not timed | not timed | 107.19 ± 0.8% | 42.26 ± 3.0% | not timed | not timed | 18120.54 ± 3.4% | | 1.00 | 169.40 | 429.69 |
| folly/literal-never-match-rare | 0 | 24854.35 ± 0.3% | not timed | not timed | 22719.16 ± 1.0% | 28758.59 ± 0.9% | not timed | not timed | 24870.79 ± 0.6% | | 1.00 | 1.09 | 0.86 |
| folly/literal-never-match-frequent | 0 | 14530.37 ± 1.7% | not timed | not timed | 22714.28 ± 0.4% | 2085.36 ± 1.6% | not timed | not timed | 14581.81 ± 1.0% | | 1.00 | 0.64 | 6.97 |
| folly/literal-never-match-tricksy | 1 | 3357.28 ± 0.6% | not timed | not timed | 4198.74 ± 24.1% | 1297.45 ± 1.0% | not timed | not timed | 3353.82 ± 0.5% | | 1.00 | 0.80 | 2.59 |
| grep/every-line | 239963 | 1151.49 ± 0.5% | not timed | not timed | 745.79 ± 0.7% | 322.51 ± 27.2% | not timed | not timed | 1158.36 ± 1.2% | | 0.99 | 1.54 | 3.57 |
| grep/long-words-ascii | 5073 | 431.46 ± 0.4% | not timed | not timed | 415.13 ± 1.8% | 40.82 ± 6.3% | not timed | not timed | 430.33 ± 2.2% | | 1.00 | 1.04 | 10.57 |
| imported/leipzig/twain | 811 | 23170.51 ± 0.4% | not timed | not timed | 22035.97 ± 1.3% | 9922.33 ± 1.2% | not timed | not timed | 23157.17 ± 0.9% | | 1.00 | 1.05 | 2.34 |
| imported/leipzig/twain-insensitive | 965 | 10388.51 ± 1.9% | not timed | not timed | 8928.24 ± 0.7% | 40.80 ± 0.2% | not timed | not timed | 10430.84 ± 2.0% | | 1.00 | 1.16 | 254.64 |
| imported/leipzig/shing | 1540 | 16371.09 ± 2.6% | not timed | not timed | 13815.10 ± 1.4% | 32.38 ± 2.8% | not timed | not timed | 16749.13 ± 4.8% | | 0.98 | 1.19 | 505.67 |
| imported/leipzig/huck-saw | 262 | 14724.84 ± 5.0% | not timed | not timed | 13694.51 ± 1.1% | 33.62 ± 0.5% | not timed | not timed | 15315.42 ± 5.0% | | 0.96 | 1.08 | 437.97 |
| imported/leipzig/word-ending-nn | 262 | 510.66 ± 1.6% | not timed | not timed | 507.00 ± 0.1% | 22.85 ± 1.4% | not timed | not timed | 510.42 ± 0.2% | | 1.00 | 1.01 | 22.35 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 8136.38 ± 11.0% | not timed | not timed | 3466.07 ± 1.4% | 9.81 ± 1.3% | not timed | not timed | 8275.67 ± 6.6% | | 0.98 | 2.35 | 829.80 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 12894.33 ± 18.0% | not timed | not timed | 12447.83 ± 1.0% | 17.99 ± 1.8% | not timed | not timed | 13244.69 ± 5.1% | | 0.97 | 1.04 | 716.86 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4445.52 ± 1.7% | not timed | not timed | 799.51 ± 6.0% | 10.11 ± 1.6% | not timed | not timed | 4447.22 ± 4.4% | | 1.00 | 5.56 | 439.73 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 11699.26 ± 28.7% | not timed | not timed | 506.04 ± 1.0% | 11.35 ± 0.9% | not timed | not timed | 11688.28 ± 4.8% | | 1.00 | 23.12 | 1031.07 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 11137.28 ± 14.9% | not timed | not timed | 505.13 ± 0.5% | 9.37 ± 1.7% | not timed | not timed | 11054.92 ± 8.9% | | 1.01 | 22.05 | 1188.30 |
| imported/leipzig/tom-river | 2 | 9037.03 ± 3.2% | not timed | not timed | 10105.25 ± 2.4% | 32.42 ± 0.4% | not timed | not timed | 9259.17 ± 6.8% | | 0.98 | 0.89 | 278.72 |
| imported/leipzig/ing | 78424 | 499.68 ± 0.5% | not timed | not timed | 469.98 ± 1.6% | 26.47 ± 4.5% | not timed | not timed | 500.71 ± 3.6% | | 1.00 | 1.06 | 18.87 |
| imported/leipzig/ing-whitespace | 55248 | 1562.52 ± 0.5% | not timed | not timed | 1777.85 ± 1.5% | 19.35 ± 2.2% | not timed | not timed | 1561.30 ± 1.7% | | 1.00 | 0.88 | 80.76 |
| imported/leipzig/awyer-inn | 209 | 7108.20 ± 2.1% | not timed | not timed | 8995.62 ± 1.3% | 21.69 ± 0.5% | not timed | not timed | 7197.02 ± 3.8% | | 0.99 | 0.79 | 327.78 |
| imported/leipzig/quotes-bounded | 8886 | 1940.40 ± 0.8% | not timed | not timed | 2623.32 ± 2.0% | 35.47 ± 0.3% | not timed | not timed | 1936.80 ± 1.5% | | 1.00 | 0.74 | 54.70 |
| imported/leipzig/non-ascii-alternate | 2 | 17925.71 ± 10.1% | not timed | not timed | 13766.90 ± 1.6% | 47.83 ± 2.8% | not timed | not timed | 18555.69 ± 4.8% | | 0.97 | 1.30 | 374.77 |
| imported/leipzig/math-symbols | 69 | 2004.98 ± 0.5% | not timed | not timed | 506.68 ± 0.9% | 34.20 ± 0.3% | not timed | not timed | 2006.95 ± 0.2% | | 1.00 | 3.96 | 58.62 |
| imported/leipzig/bounded-strings-ending-z | 0 | 510.09 ± 0.7% | not timed | not timed | 505.20 ± 1.0% | 23.54 ± 0.8% | not timed | not timed | 510.90 ± 0.2% | | 1.00 | 1.01 | 21.67 |
| imported/lh3lh3-reb/uri | 17549 | 691.78 ± 9.6% | not timed | not timed | 848.97 ± 0.4% | 24.72 ± 2.3% | not timed | not timed | 693.19 ± 0.4% | | 1.00 | 0.81 | 27.99 |
| imported/lh3lh3-reb/email | 15057 | 689.12 ± 2.1% | not timed | not timed | 847.61 ± 11.1% | 28.18 ± 2.4% | not timed | not timed | 686.42 ± 0.4% | | 1.00 | 0.81 | 24.46 |
| imported/lh3lh3-reb/date | 668 | 726.86 ± 0.5% | not timed | not timed | 763.01 ± 0.8% | 43.84 ± 1.8% | not timed | not timed | 731.75 ± 1.5% | | 0.99 | 0.95 | 16.58 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 634.49 ± 4.1% | not timed | not timed | 377.88 ± 4.2% | 13.92 ± 1.7% | not timed | not timed | 635.16 ± 4.7% | | 1.00 | 1.68 | 45.58 |
| imported/mariomka/email | 92 | 20902.69 ± 3.2% | not timed | not timed | 24621.31 ± 7.6% | 30.50 ± 5.6% | not timed | not timed | 20899.23 ± 1.0% | | 1.00 | 0.85 | 685.40 |
| imported/mariomka/uri | 5301 | 5276.68 ± 1.1% | not timed | not timed | 5923.95 ± 0.7% | 31.06 ± 3.1% | not timed | not timed | 5285.75 ± 6.2% | | 1.00 | 0.89 | 169.88 |
| imported/mariomka/ip | 5 | 1944.88 ± 4.6% | not timed | not timed | 1945.83 ± 0.7% | 20.91 ± 1.0% | not timed | not timed | 1955.91 ± 5.0% | | 0.99 | 1.00 | 93.03 |
| imported/rsc/no-exponential | 0 | 824.37 ± 0.6% | not timed | not timed | 516.93 ± 0.8% | 22.19 ± 1.9% | not timed | not timed | 823.36 ± 1.2% | | 1.00 | 1.59 | 37.15 |
| imported/rsc/literal | 1 | 1605.75 ± 12.4% | not timed | not timed | 2199.84 ± 0.5% | 219.69 ± 18.3% | not timed | not timed | 1735.56 ± 18.4% | | 0.93 | 0.73 | 7.31 |
| imported/rsc/not-literal | 2 | 770.98 ± 1.6% | not timed | not timed | 1076.58 ± 1.0% | 45.17 ± 3.1% | not timed | not timed | 770.16 ± 9.0% | | 1.00 | 0.72 | 17.07 |
| imported/rsc/match-class | 1 | 1612.62 ± 4.9% | not timed | not timed | 2249.93 ± 1.5% | 52.87 ± 2.0% | not timed | not timed | 1617.81 ± 8.3% | | 1.00 | 0.72 | 30.50 |
| imported/rsc/match-class-in-range | 1 | 1619.89 ± 3.9% | not timed | not timed | 3490.51 ± 0.3% | 57.96 ± 17.0% | not timed | not timed | 1620.69 ± 9.9% | | 1.00 | 0.46 | 27.95 |
| imported/rsc/match-class-unicode | 1 | 494.25 ± 1.7% | not timed | not timed | 474.67 ± 0.2% | 63.55 ± 6.7% | not timed | not timed | 494.83 ± 0.4% | | 1.00 | 1.04 | 7.78 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1254.78 ± 1.5% | not timed | not timed | 1124.01 ± 2.7% | 285.79 ± 1.1% | not timed | not timed | 1259.21 ± 3.2% | | 1.00 | 1.12 | 4.39 |
| imported/rsc/anchored-literal-long-non-match | 0 | 18942.81 ± 4.2% | not timed | not timed | 16782.33 ± 2.7% | 4253.40 ± 2.5% | not timed | not timed | 18957.44 ± 0.5% | | 1.00 | 1.13 | 4.45 |
| imported/rsc/anchored-literal-short-match | 4 | 670.69 ± 4.2% | not timed | not timed | 793.90 ± 1.0% | 85.02 ± 38.1% | not timed | not timed | 674.58 ± 4.4% | | 0.99 | 0.84 | 7.89 |
| imported/rsc/anchored-literal-long-match | 4 | 10076.32 ± 2.6% | not timed | not timed | 11917.24 ± 0.7% | 1306.88 ± 7.7% | not timed | not timed | 10055.45 ± 4.7% | | 1.00 | 0.85 | 7.71 |
| imported/rsc/one-pass-short | 17 | 397.53 ± 10.4% | not timed | not timed | 367.50 ± 6.1% | 30.56 ± 14.8% | not timed | not timed | 413.21 ± 5.1% | | 0.96 | 1.08 | 13.01 |
| imported/rsc/one-pass-short-not | 17 | 367.03 ± 4.1% | not timed | not timed | 359.06 ± 11.3% | 28.74 ± 12.0% | not timed | not timed | 367.48 ± 8.4% | | 1.00 | 1.02 | 12.77 |
| imported/rsc/one-pass-long-prefix | 26 | 471.64 ± 9.3% | not timed | not timed | 431.83 ± 0.4% | 95.39 ± 19.7% | not timed | not timed | 483.16 ± 3.4% | | 0.98 | 1.09 | 4.94 |
| imported/rsc/one-pass-long-prefix-not | 26 | 484.89 ± 2.4% | not timed | not timed | 433.29 ± 0.5% | 73.36 ± 27.8% | not timed | not timed | 476.75 ± 3.3% | | 1.02 | 1.12 | 6.61 |
| imported/rsc/long-needle1 | 31 | 30634.73 ± 4.1% | not timed | not timed | 27446.00 ± 0.4% | 3.16 ± 2.4% | not timed | not timed | 30640.96 ± 2.1% | | 1.00 | 1.12 | 9690.22 |
| imported/rsc/long-needle2 | 31 | 30410.17 ± 3.8% | not timed | not timed | 171.32 ± 2.7% | 3.16 ± 2.8% | not timed | not timed | 30426.91 ± 0.7% | | 1.00 | 177.51 | 9615.77 |
| imported/rsc/easy0-32 | 26 | 1873.09 ± 2.3% | not timed | not timed | 2034.01 ± 0.5% | 146.80 ± 20.7% | not timed | not timed | 1840.53 ± 7.8% | | 1.02 | 0.92 | 12.76 |
| imported/rsc/easy0-1k | 26 | 17311.43 ± 2.3% | not timed | not timed | 18157.49 ± 2.8% | 2581.40 ± 31.8% | not timed | not timed | 17326.14 ± 12.3% | | 1.00 | 0.95 | 6.71 |
| imported/rsc/easy0-32k | 26 | 38702.74 ± 3.0% | not timed | not timed | 31508.61 ± 1.0% | 20774.49 ± 33.9% | not timed | not timed | 38714.06 ± 0.3% | | 1.00 | 1.23 | 1.86 |
| imported/rsc/easy0-1mb | 26 | 31147.27 ± 0.8% | not timed | not timed | 30600.24 ± 2.0% | 41412.56 ± 0.6% | not timed | not timed | 31146.51 ± 0.4% | | 1.00 | 1.02 | 0.75 |
| imported/rsc/easy1-32 | 19 | 1061.65 ± 2.7% | not timed | not timed | 1066.03 ± 0.4% | 139.71 ± 18.6% | not timed | not timed | 1061.29 ± 7.2% | | 1.00 | 1.00 | 7.60 |
| imported/rsc/easy1-1k | 19 | 21818.74 ± 1.9% | not timed | not timed | 21735.26 ± 0.2% | 2603.13 ± 18.6% | not timed | not timed | 21768.09 ± 3.2% | | 1.00 | 1.00 | 8.38 |
| imported/rsc/easy1-32k | 19 | 685125.79 ± 3.3% | not timed | not timed | 680255.16 ± 0.7% | 22871.90 ± 26.8% | not timed | not timed | 685588.99 ± 0.5% | | 1.00 | 1.01 | 29.95 |
| imported/rsc/easy1-1mb | 19 | 21824651.90 ± 1.4% | not timed | not timed | 21847153.33 ± 0.2% | 43731.69 ± 2.9% | not timed | not timed | 21960263.10 ± 0.3% | | 0.99 | 1.00 | 499.06 |
| imported/rsc/medium-32 | 27 | 971.19 ± 1.3% | not timed | not timed | 989.51 ± 2.8% | 68.36 ± 9.3% | not timed | not timed | 972.96 ± 11.5% | | 1.00 | 0.98 | 14.21 |
| imported/rsc/medium-1k | 27 | 17224.46 ± 2.6% | not timed | not timed | 17679.02 ± 11.3% | 70.71 ± 1.2% | not timed | not timed | 17299.82 ± 1.0% | | 1.00 | 0.97 | 243.61 |
| imported/rsc/medium-32k | 27 | 536871.91 ± 8.1% | not timed | not timed | 550298.41 ± 0.6% | 52.05 ± 0.8% | not timed | not timed | 540043.05 ± 0.8% | | 0.99 | 0.98 | 10315.14 |
| imported/rsc/medium-1mb | 27 | 17229111.43 ± 8.7% | not timed | not timed | 17598273.97 ± 3.6% | 52.68 ± 9.0% | not timed | not timed | 17328296.69 ± 0.9% | | 0.99 | 0.98 | 327050.63 |
| imported/rsc/hard-32 | 58 | 457.00 ± 0.3% | not timed | not timed | 397.21 ± 0.2% | 48.36 ± 9.7% | not timed | not timed | 455.66 ± 2.0% | | 1.00 | 1.15 | 9.45 |
| imported/rsc/hard-1k | 27 | 16649.95 ± 1.5% | not timed | not timed | 15485.54 ± 0.4% | 39.89 ± 0.9% | not timed | not timed | 16763.22 ± 1.8% | | 0.99 | 1.08 | 417.42 |
| imported/rsc/hard-32k | 27 | 522957.69 ± 0.6% | not timed | not timed | 484236.34 ± 0.8% | 30.27 ± 0.9% | not timed | not timed | 523566.79 ± 0.1% | | 1.00 | 1.08 | 17275.07 |
| imported/rsc/hard-1mb | 51 | 9256272.75 ± 0.6% | not timed | not timed | 8100725.97 ± 0.2% | 30.11 ± 1.0% | not timed | not timed | 9265778.44 ± 0.4% | | 1.00 | 1.14 | 307418.15 |
| imported/rsc/reallyhard0-32 | 58 | 267.08 ± 0.6% | not timed | not timed | 238.53 ± 1.4% | 49.43 ± 11.9% | not timed | not timed | 266.15 ± 3.0% | | 1.00 | 1.12 | 5.40 |
| imported/rsc/reallyhard0-1k | 27 | 502.28 ± 0.3% | not timed | not timed | 498.07 ± 0.2% | 40.20 ± 0.7% | not timed | not timed | 501.48 ± 1.1% | | 1.00 | 1.01 | 12.49 |
| imported/rsc/reallyhard0-32k | 27 | 509.86 ± 12.2% | not timed | not timed | 511.43 ± 2.4% | 29.60 ± 1.8% | not timed | not timed | 510.58 ± 4.3% | | 1.00 | 1.00 | 17.23 |
| imported/rsc/reallyhard0-1mb | 51 | 511.18 ± 0.4% | not timed | not timed | 511.94 ± 0.5% | 30.05 ± 0.8% | not timed | not timed | 511.91 ± 0.3% | | 1.00 | 1.00 | 17.01 |
| imported/rsc/reallyreallyhard0-32 | 47 | 299.61 ± 1.5% | not timed | not timed | 217.90 ± 4.9% | 59.45 ± 15.7% | not timed | not timed | 299.33 ± 3.7% | | 1.00 | 1.38 | 5.04 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7151.04 ± 0.3% | not timed | not timed | 8373.93 ± 0.6% | 32.22 ± 0.9% | not timed | not timed | 7144.19 ± 0.5% | | 1.00 | 0.85 | 221.93 |
| imported/rsc/reallyreallyhard0-32k | 16 | 35398.92 ± 3.2% | not timed | not timed | 29508.95 ± 1.5% | 24.34 ± 0.1% | not timed | not timed | 35447.54 ± 0.2% | | 1.00 | 1.20 | 1454.42 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 34776.57 ± 4.8% | not timed | not timed | 30103.82 ± 24.1% | 24.40 ± 1.2% | not timed | not timed | 34781.18 ± 2.2% | | 1.00 | 1.16 | 1425.06 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 290.32 ± 1.4% | not timed | not timed | 215.89 ± 2.7% | 58.40 ± 11.4% | not timed | not timed | 290.67 ± 1.1% | | 1.00 | 1.34 | 4.97 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5857.02 ± 1.8% | not timed | not timed | 7993.20 ± 1.2% | 32.01 ± 4.3% | not timed | not timed | 5876.22 ± 0.9% | | 1.00 | 0.73 | 182.96 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 33869.80 ± 0.6% | not timed | not timed | 29484.98 ± 1.5% | 24.35 ± 0.5% | not timed | not timed | 33893.48 ± 0.2% | | 1.00 | 1.15 | 1391.20 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 30728.00 ± 1.2% | not timed | not timed | 27051.81 ± 0.7% | 24.43 ± 0.5% | not timed | not timed | 30726.42 ± 0.2% | | 1.00 | 1.14 | 1257.92 |
| imported/sherlock/name-sherlock | 776 | 26227.24 ± 8.1% | not timed | not timed | 24996.42 ± 0.3% | 8685.10 ± 25.6% | not timed | not timed | 26214.05 ± 1.2% | | 1.00 | 1.05 | 3.02 |
| imported/sherlock/name-holmes | 2766 | 15409.17 ± 5.2% | not timed | not timed | 19803.76 ± 2.9% | 3145.83 ± 8.3% | not timed | not timed | 16075.42 ± 2.0% | | 0.96 | 0.78 | 4.90 |
| imported/sherlock/name-sherlock-holmes | 1365 | 26079.86 ± 2.1% | not timed | not timed | 24616.25 ± 0.2% | 8122.13 ± 53.4% | not timed | not timed | 26376.68 ± 0.3% | | 0.99 | 1.06 | 3.21 |
| imported/sherlock/name-sherlock-casei | 816 | 23707.66 ± 0.9% | not timed | not timed | 8143.89 ± 0.2% | 29.52 ± 2.4% | not timed | not timed | 23824.71 ± 0.3% | | 1.00 | 2.91 | 803.18 |
| imported/sherlock/name-holmes-casei | 2802 | 13526.84 ± 2.3% | not timed | not timed | 5681.59 ± 0.6% | 41.46 ± 0.3% | not timed | not timed | 13559.55 ± 2.7% | | 1.00 | 2.38 | 326.30 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 20763.66 ± 0.9% | not timed | not timed | 7966.46 ± 3.2% | 29.34 ± 3.2% | not timed | not timed | 20829.06 ± 0.3% | | 1.00 | 2.61 | 707.69 |
| imported/sherlock/name-whitespace | 1461 | 19166.28 ± 1.9% | not timed | not timed | 19752.53 ± 0.5% | 7218.73 ± 23.8% | not timed | not timed | 19174.47 ± 2.0% | | 1.00 | 0.97 | 2.66 |
| imported/sherlock/name-alt1 | 1142 | 17690.19 ± 2.4% | not timed | not timed | 27303.23 ± 7.3% | 4019.10 ± 33.4% | not timed | not timed | 17693.41 ± 0.6% | | 1.00 | 0.65 | 4.40 |
| imported/sherlock/name-alt2 | 3542 | 11708.93 ± 1.5% | not timed | not timed | 7116.26 ± 1.0% | 32.82 ± 3.5% | not timed | not timed | 11734.38 ± 1.4% | | 1.00 | 1.65 | 356.79 |
| imported/sherlock/name-alt3 | 4507 | 8485.35 ± 4.5% | not timed | not timed | 6386.99 ± 2.4% | 10.35 ± 6.5% | not timed | not timed | 8312.63 ± 5.1% | | 1.02 | 1.33 | 819.90 |
| imported/sherlock/name-alt3-casei | 4593 | 1403.86 ± 2.2% | not timed | not timed | 1143.02 ± 0.4% | 6.31 ± 0.6% | not timed | not timed | 1410.42 ± 6.5% | | 1.00 | 1.23 | 222.59 |
| imported/sherlock/name-alt4 | 3686 | 8019.49 ± 0.8% | not timed | not timed | 6687.48 ± 0.7% | 32.88 ± 10.3% | not timed | not timed | 8005.61 ± 6.7% | | 1.00 | 1.20 | 243.93 |
| imported/sherlock/name-alt4-casei | 4254 | 3221.32 ± 17.7% | not timed | not timed | 3391.85 ± 1.8% | 17.84 ± 2.4% | not timed | not timed | 3239.79 ± 0.3% | | 0.99 | 0.95 | 180.54 |
| imported/sherlock/name-alt5 | 4028 | 10262.45 ± 1.0% | not timed | not timed | 6857.88 ± 0.9% | 22.96 ± 2.1% | not timed | not timed | 10276.76 ± 1.0% | | 1.00 | 1.50 | 447.04 |
| imported/sherlock/name-alt5-casei | 4104 | 4584.68 ± 7.7% | not timed | not timed | 2372.40 ± 0.3% | 13.07 ± 0.5% | not timed | not timed | 4566.50 ± 4.8% | | 1.00 | 1.93 | 350.75 |
| imported/sherlock/no-match-uncommon | 0 | 30966.63 ± 20.1% | not timed | not timed | 26361.11 ± 0.9% | 39148.15 ± 0.4% | not timed | not timed | 31016.53 ± 6.1% | | 1.00 | 1.17 | 0.79 |
| imported/sherlock/no-match-common | 0 | 30635.44 ± 0.4% | not timed | not timed | 26370.55 ± 0.1% | 1607.60 ± 0.4% | not timed | not timed | 30656.43 ± 1.3% | | 1.00 | 1.16 | 19.06 |
| imported/sherlock/no-match-really-common | 0 | 25185.68 ± 1.7% | not timed | not timed | 26184.12 ± 4.9% | 1605.42 ± 1.0% | not timed | not timed | 25506.87 ± 10.8% | | 0.99 | 0.96 | 15.69 |
| imported/sherlock/the-lower | 21654 | 2044.44 ± 2.1% | not timed | not timed | 1938.79 ± 5.2% | 230.93 ± 20.9% | not timed | not timed | 2045.43 ± 2.5% | | 1.00 | 1.05 | 8.85 |
| imported/sherlock/the-upper | 2223 | 12002.41 ± 3.4% | not timed | not timed | 17293.10 ± 3.4% | 2624.02 ± 16.0% | not timed | not timed | 12188.75 ± 2.3% | | 0.98 | 0.69 | 4.57 |
| imported/sherlock/the-casei | 23961 | 1911.23 ± 1.1% | not timed | not timed | 1156.20 ± 1.5% | 36.99 ± 15.4% | not timed | not timed | 1925.39 ± 2.6% | | 0.99 | 1.65 | 51.67 |
| imported/sherlock/everything-greedy | 581881 | 263.07 ± 1.6% | not timed | not timed | 150.12 ± 2.1% | 25.67 ± 29.1% | not timed | not timed | 263.06 ± 0.8% | | 1.00 | 1.75 | 10.25 |
| imported/sherlock/everything-greedy-nl | 594933 | 428.48 ± 0.7% | not timed | not timed | 193.08 ± 0.9% | 27.41 ± 2.9% | not timed | not timed | 428.74 ± 0.4% | | 1.00 | 2.22 | 15.63 |
| imported/sherlock/letters | 447175 | 60.95 ± 0.4% | not timed | not timed | 33.60 ± 0.6% | 4.58 ± 18.6% | not timed | not timed | 61.07 ± 8.3% | | 1.00 | 1.81 | 13.32 |
| imported/sherlock/letters-upper | 14180 | 387.46 ± 1.3% | not timed | not timed | 320.19 ± 0.8% | 25.88 ± 26.4% | not timed | not timed | 390.13 ± 1.2% | | 0.99 | 1.21 | 14.97 |
| imported/sherlock/letters-lower | 432995 | 61.13 ± 3.8% | not timed | not timed | 34.28 ± 1.3% | 5.07 ± 13.9% | not timed | not timed | 61.21 ± 8.0% | | 1.00 | 1.78 | 12.07 |
| imported/sherlock/words | 447639 | 105.78 ± 1.0% | not timed | not timed | 74.88 ± 0.5% | 12.37 ± 34.3% | not timed | not timed | 106.42 ± 0.8% | | 0.99 | 1.41 | 8.55 |
| imported/sherlock/before-holmes | 4073 | 10080.87 ± 6.8% | not timed | not timed | 11802.42 ± 1.0% | 22.41 ± 4.3% | not timed | not timed | 10090.17 ± 18.2% | | 1.00 | 0.85 | 449.87 |
| imported/sherlock/before-after-holmes | 2593 | 10073.61 ± 2.9% | not timed | not timed | 12573.72 ± 3.3% | 22.42 ± 0.8% | not timed | not timed | 10203.06 ± 2.7% | | 0.99 | 0.80 | 449.23 |
| imported/sherlock/holmes-cochar-watson | 150 | 7618.25 ± 8.2% | not timed | not timed | 5828.17 ± 5.1% | 33.18 ± 2.2% | not timed | not timed | 7660.42 ± 14.2% | | 0.99 | 1.31 | 229.62 |
| imported/sherlock/holmes-coword-watson | 14309 | 1053.22 ± 0.3% | not timed | not timed | 1042.11 ± 0.4% | 6.13 ± 0.8% | not timed | not timed | 1053.81 ± 0.1% | | 1.00 | 1.01 | 171.92 |
| imported/sherlock/quotes | 14437 | 1229.61 ± 1.0% | not timed | not timed | 1623.97 ± 4.7% | 32.49 ± 1.0% | not timed | not timed | 1221.73 ± 4.7% | | 1.01 | 0.76 | 37.85 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 22267.56 ± 2.0% | not timed | not timed | 21215.63 ± 5.3% | 38.42 ± 0.3% | not timed | not timed | 22287.76 ± 0.3% | | 1.00 | 1.05 | 579.65 |
| imported/sherlock/word-ending-n | 35297 | 395.98 ± 1.0% | not timed | not timed | 344.68 ± 1.4% | 21.55 ± 22.5% | not timed | not timed | 397.70 ± 1.5% | | 1.00 | 1.15 | 18.37 |
| imported/sherlock/repeated-class-negation | 2130 | 13060.72 ± 5.2% | not timed | not timed | 14684.92 ± 2.9% | 9.92 ± 0.6% | not timed | not timed | 13149.51 ± 3.6% | | 0.99 | 0.89 | 1316.27 |
| imported/sherlock/ing-suffix | 20547 | 479.49 ± 0.4% | not timed | not timed | 434.74 ± 0.2% | 26.68 ± 0.8% | not timed | not timed | 480.83 ± 1.5% | | 1.00 | 1.10 | 17.97 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1400.20 ± 2.2% | not timed | not timed | 2095.68 ± 5.7% | 19.38 ± 0.7% | not timed | not timed | 1401.72 ± 2.4% | | 1.00 | 0.67 | 72.24 |
| opt/accelerate/whole-line | 239963 | 436.99 ± 0.5% | not timed | not timed | 352.05 ± 0.3% | 90.02 ± 14.5% | not timed | not timed | 437.47 ± 0.8% | | 1.00 | 1.24 | 4.85 |
| opt/accelerate/non-dna | 16745 | 428.28 ± 0.6% | not timed | not timed | 400.34 ± 1.0% | 30.03 ± 80.7% | not timed | not timed | 428.25 ± 0.3% | | 1.00 | 1.07 | 14.26 |
| opt/backtrack/words-english | 40536 | 119.77 ± 2.6% | not timed | not timed | 99.34 ± 2.0% | 18.09 ± 6.8% | not timed | not timed | 120.48 ± 0.3% | | 0.99 | 1.21 | 6.62 |
| opt/fixed-length/too-small-ascii | 0 | 339.87 ± 8.2% | not timed | not timed | 748.67 ± 16.0% | 106.21 ± 4.8% | not timed | not timed | 341.02 ± 4.9% | | 1.00 | 0.45 | 3.20 |
| opt/fixed-length/too-big-ascii | 0 | 4019.39 ± 1.5% | not timed | not timed | 6298.05 ± 2.6% | 132.92 ± 0.9% | not timed | not timed | 4024.39 ± 3.4% | | 1.00 | 0.64 | 30.24 |
| opt/fixed-length/go33484-1 | 0 | 774159.59 ± 5.4% | not timed | not timed | 1215801.67 ± 4.1% | 70366.11 ± 1.2% | not timed | not timed | 774582.39 ± 2.5% | | 1.00 | 0.64 | 11.00 |
| opt/fixed-length/go33484-2 | 0 | 770164.88 ± 1.2% | not timed | not timed | 1200181.13 ± 4.4% | 36871.83 ± 0.7% | not timed | not timed | 766281.89 ± 2.5% | | 1.01 | 0.64 | 20.89 |
| opt/fixed-length/go33484-3 | 0 | 78053.60 ± 3.9% | not timed | not timed | 121375.80 ± 1.2% | 863.07 ± 1.6% | not timed | not timed | 78503.42 ± 1.7% | | 0.99 | 0.64 | 90.44 |
| opt/literal-alt/one-pattern | 1 | 518.79 ± 1.8% | not timed | not timed | 521.20 ± 0.2% | 0.37 ± 1.3% | not timed | not timed | 518.58 ± 1.7% | | 1.00 | 1.00 | 1393.29 |
| opt/onepass/fn-predicate | 916 | 383.59 ± 1.3% | not timed | not timed | 347.96 ± 0.7% | 194.39 ± 43.2% | not timed | not timed | 383.79 ± 0.9% | | 1.00 | 1.10 | 1.97 |
| opt/onepass/first-three-words-english | 35128 | 143.14 ± 20.6% | not timed | not timed | 194.60 ± 7.7% | 69.57 ± 20.8% | not timed | not timed | 148.03 ± 7.0% | | 0.97 | 0.74 | 2.06 |
| opt/prefilter/literal-english | 1 | 30269.92 ± 24.7% | not timed | not timed | 26891.40 ± 4.6% | 19124.26 ± 7.7% | not timed | not timed | 30336.52 ± 0.3% | | 1.00 | 1.13 | 1.58 |
| opt/prefilter/literal-casei-english | 1 | 24127.76 ± 1.4% | not timed | not timed | 9467.11 ± 0.1% | 30.14 ± 1.3% | not timed | not timed | 24096.43 ± 6.3% | | 1.00 | 2.55 | 800.39 |
| opt/prefilter/literal-russian | 1 | 31369.52 ± 0.4% | not timed | not timed | 27330.55 ± 0.3% | 1524.05 ± 10.7% | not timed | not timed | 31320.17 ± 6.5% | | 1.00 | 1.15 | 20.58 |
| opt/prefilter/literal-casei-russian | 1 | 17951.13 ± 0.2% | not timed | not timed | 7482.28 ± 0.3% | 33.22 ± 1.3% | not timed | not timed | 17936.39 ± 4.0% | | 1.00 | 2.40 | 540.42 |
| opt/prefilter/rust-functions | 948 | 10527.79 ± 1.3% | not timed | not timed | 9043.65 ± 0.7% | 1666.50 ± 1.2% | not timed | not timed | 10444.86 ± 2.1% | | 1.01 | 1.16 | 6.32 |
| opt/reverse-anchored/word-end | 1 | 33598458.16 ± 1.7% | not timed | not timed | 30322649.89 ± 0.6% | 49.01 ± 0.9% | not timed | not timed | 33334692.33 ± 1.8% | | 1.01 | 1.11 | 685522.01 |
| opt/reverse-inner/holmes | 2593 | 9996.31 ± 3.3% | not timed | not timed | 12681.44 ± 1.4% | 22.49 ± 2.4% | not timed | not timed | 10161.75 ± 2.4% | | 0.98 | 0.79 | 444.39 |
| opt/reverse-inner/email | 47 | 29816.39 ± 1.3% | not timed | not timed | 29275.10 ± 0.5% | 30.73 ± 0.4% | not timed | not timed | 29873.16 ± 0.9% | | 1.00 | 1.02 | 970.13 |
| opt/reverse-inner/factored-prefix | 3542 | 504.27 ± 3.6% | not timed | not timed | 498.55 ± 18.4% | 11.77 ± 1.0% | not timed | not timed | 503.80 ± 0.6% | | 1.00 | 1.01 | 42.84 |
| opt/reverse-inner/no-quadratic-backward | 0 | 18291.18 ± 2.3% | not timed | not timed | 511.83 ± 0.1% | 68.16 ± 1.0% | not timed | not timed | 18276.98 ± 0.8% | | 1.00 | 35.74 | 268.37 |
| opt/reverse-inner/no-quadratic-forward | 0 | 594.44 ± 4.7% | not timed | not timed | 235.88 ± 0.3% | 25.06 ± 1.2% | not timed | not timed | 593.72 ± 7.9% | | 1.00 | 2.52 | 23.72 |
| opt/reverse-suffix/holmes | 4073 | 10070.59 ± 3.5% | not timed | not timed | 11687.65 ± 3.5% | 22.46 ± 0.3% | not timed | not timed | 10090.13 ± 1.6% | | 1.00 | 0.86 | 448.47 |
| opt/reverse-suffix/no-quadratic | 0 | 17647.48 ± 0.4% | not timed | not timed | 511.52 ± 0.5% | 68.30 ± 7.8% | not timed | not timed | 17687.19 ± 17.4% | | 1.00 | 34.50 | 258.37 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 117.53 ± 8.1% | not timed | not timed | 162.80 ± 3.1% | 13.79 ± 16.9% | not timed | not timed | 118.24 ± 4.8% | | 0.99 | 0.72 | 8.53 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 118.88 ± 3.7% | not timed | not timed | 161.57 ± 25.2% | 13.43 ± 28.0% | not timed | not timed | 118.71 ± 23.6% | | 1.00 | 0.74 | 8.85 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.30 ± 0.6% | not timed | not timed | 0.48 ± 1.2% | 107.86 ± 0.8% | not timed | not timed | 0.30 ± 0.6% | | 1.01 | 0.63 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 273.72 ± 0.5% | not timed | not timed | 256.11 ± 0.2% | 93.50 ± 12.7% | not timed | not timed | 273.37 ± 4.2% | | 1.00 | 1.07 | 2.93 |
| reported/i13-subset-regex/original-ascii | 4094 | 8273.05 ± 2.4% | not timed | not timed | 3513.61 ± 0.5% | 9.82 ± 1.4% | not timed | not timed | 8424.75 ± 1.6% | | 0.98 | 2.35 | 842.84 |
| reported/i13-subset-regex/original-unicode | 4094 | 8276.82 ± 1.4% | not timed | not timed | 198.75 ± 1.9% | 9.76 ± 0.9% | not timed | not timed | 8294.46 ± 2.1% | | 1.00 | 41.65 | 847.71 |
| reported/i13-subset-regex/big-ascii | 1955 | 7791.56 ± 2.4% | not timed | not timed | 51.97 ± 2.8% | 8.58 ± 0.7% | not timed | not timed | 7814.55 ± 3.8% | | 1.00 | 149.91 | 908.13 |
| reported/i13-subset-regex/big-unicode | 1955 | 7805.64 ± 1.9% | not timed | not timed | 9.32 ± 54.9% | 8.60 ± 0.8% | not timed | not timed | 7812.60 ± 1.9% | | 1.00 | 837.40 | 907.38 |
| reported/i13-subset-regex/huge-ascii | 55 | 7242.13 ± 3.2% | not timed | not timed | 8.36 ± 2.4% | 8.14 ± 1.1% | not timed | not timed | 7268.19 ± 2.5% | | 1.00 | 865.77 | 889.37 |
| reported/i13-subset-regex/huge-unicode | 55 | 7179.24 ± 11.1% | not timed | not timed | 8.70 ± 0.9% | 8.12 ± 0.3% | not timed | not timed | 7183.14 ± 15.8% | | 1.00 | 824.89 | 883.81 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.58 ± 0.4% | not timed | not timed | 8.89 ± 0.6% | 8.17 ± 0.2% | not timed | not timed | 3.58 ± 0.6% | | 1.00 | 0.40 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.01 ± 1.3% | not timed | not timed | 8.88 ± 1.0% | 8.11 ± 0.9% | not timed | not timed | 5.02 ± 0.9% | | 1.00 | 0.56 | 0.62 |
| reported/i787-keywords/ascii | 5674 | 460.63 ± 2.5% | not timed | not timed | 117.24 ± 0.3% | 6.56 ± 0.7% | not timed | not timed | 467.10 ± 1.9% | | 0.99 | 3.93 | 70.20 |
| reported/i787-keywords/opt-ascii | 5674 | 461.17 ± 17.5% | not timed | not timed | 239.66 ± 2.8% | 10.36 ± 1.8% | not timed | not timed | 461.40 ± 3.0% | | 1.00 | 1.92 | 44.52 |
| slow/quadratic-regex-1x | 100 | 7.41 ± 0.4% | not timed | not timed | 5.48 ± 0.4% | 0.05 ± 0.9% | not timed | not timed | 7.41 ± 2.8% | | 1.00 | 1.35 | 149.10 |
| slow/quadratic-regex-2x | 199 | 3.22 ± 0.4% | not timed | not timed | 2.68 ± 5.7% | 0.01 ± 1.8% | not timed | not timed | 3.22 ± 0.7% | | 1.00 | 1.20 | 247.11 |
| slow/quadratic-haystack-1x | 100 | 23.09 ± 9.2% | not timed | not timed | 10.91 ± 0.6% | 0.99 ± 17.9% | not timed | not timed | 23.14 ± 2.4% | | 1.00 | 2.12 | 23.21 |
| slow/quadratic-haystack-2x | 200 | 21.20 ± 3.5% | not timed | not timed | 5.33 ± 0.9% | 0.56 ± 14.4% | not timed | not timed | 21.14 ± 1.6% | | 1.00 | 3.98 | 38.16 |
| unicode/codepoints/any-one | 1112064 | 289.89 ± 1.5% | not timed | not timed | 243.80 ± 0.5% | 15.30 ± 16.0% | not timed | not timed | 289.94 ± 2.1% | | 1.00 | 1.19 | 18.94 |
| unicode/codepoints/any-all | 4382592 | 232.45 ± 0.3% | not timed | not timed | 232.98 ± 0.7% | 101.84 ± 1.9% | not timed | not timed | 232.73 ± 0.3% | | 1.00 | 1.00 | 2.28 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.69 ± 0.8% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 512.02 ± 0.4% | not timed | not timed | 511.05 ± 0.4% | 148.29 ± 0.9% | not timed | not timed | 511.59 ± 0.4% | | 1.00 | 1.00 | 3.45 |
| unicode/overlapping-words/ascii | 6156 | 26.96 ± 1.3% | not timed | not timed | 40.12 ± 17.0% | 3.99 ± 2.6% | not timed | not timed | 26.82 ± 6.3% | | 1.01 | 0.67 | 6.76 |
| unicode/overlapping-words/english | 6156 | 1.39 ± 0.5% | not timed | not timed | 2.04 ± 0.2% | 2.30 ± 6.9% | not timed | not timed | 1.38 ± 11.4% | | 1.01 | 0.68 | 0.61 |
| unicode/overlapping-words/russian | 5710 | 1.19 ± 0.9% | not timed | not timed | 1.98 ± 1.7% | 5.81 ± 10.8% | not timed | not timed | 1.28 ± 8.8% | | 0.93 | 0.60 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 111.02 ± 0.8% | not timed | not timed | 74.04 ± 1.0% | 10.10 ± 8.6% | not timed | not timed | 111.33 ± 1.8% | | 1.00 | 1.50 | 11.00 |
| unicode/word/boundary-long-english | 3466 | 515.01 ± 0.6% | not timed | not timed | 503.83 ± 0.1% | 29.61 ± 0.7% | not timed | not timed | 514.74 ± 1.0% | | 1.00 | 1.02 | 17.39 |
| unicode/word/around-holmes-english | 27 | 29217.93 ± 1.1% | not timed | not timed | 26992.35 ± 9.1% | 19.96 ± 2.1% | not timed | not timed | 29262.48 ± 0.2% | | 1.00 | 1.08 | 1463.88 |
| wild/bibleref/long | 874 | 480.76 ± 1.3% | not timed | not timed | 487.76 ± 0.1% | 6.99 ± 1.4% | not timed | not timed | 480.88 ± 1.0% | | 1.00 | 0.99 | 68.80 |
| wild/bibleref/short | 30 | 21.35 ± 10.0% | not timed | not timed | 30.44 ± 7.1% | 11.24 ± 12.8% | not timed | not timed | 22.04 ± 3.6% | | 0.97 | 0.70 | 1.90 |
| wild/bibleref/line | 874 | 441.84 ± 0.3% | not timed | not timed | 222.39 ± 4.4% | 7.75 ± 0.6% | not timed | not timed | 441.33 ± 0.4% | | 1.00 | 1.99 | 56.98 |
| wild/caddy/caddy | 6 | 384.94 ± 8.5% | not timed | not timed | 236.63 ± 5.7% | 68.77 ± 14.5% | not timed | not timed | 386.28 ± 3.0% | | 1.00 | 1.63 | 5.60 |
| wild/dot-star-capture/rust-src-tools | 6 | 1041.05 ± 6.4% | not timed | not timed | 292.89 ± 0.4% | 13.16 ± 0.5% | not timed | not timed | 1099.45 ± 9.5% | | 0.95 | 3.55 | 79.11 |
| wild/ruff/noqa | 84 | 488.35 ± 0.5% | not timed | not timed | 451.12 ± 0.4% | 19.19 ± 1.7% | not timed | not timed | 489.47 ± 7.6% | | 1.00 | 1.08 | 25.45 |
| wild/ruff/unnecessary-coding-comment | 16 | 877.28 ± 0.8% | not timed | not timed | 585.19 ± 0.8% | 123.32 ± 4.2% | not timed | not timed | 879.50 ± 0.6% | | 1.00 | 1.50 | 7.11 |
| wild/ruff/string-quote-prefix | 2972 | 1324.26 ± 1.2% | not timed | not timed | 392.24 ± 0.3% | 334.08 ± 35.9% | not timed | not timed | 1329.93 ± 1.5% | | 1.00 | 3.38 | 3.96 |
| wild/ruff/space-around-operator | 1224378 | 210.94 ± 4.3% | not timed | not timed | 194.34 ± 0.9% | 16.51 ± 2.1% | not timed | not timed | 212.15 ± 3.2% | | 0.99 | 1.09 | 12.78 |
| wild/ruff/shebang | 282 | 880.57 ± 3.6% | not timed | not timed | 348.42 ± 0.8% | 109.31 ± 10.6% | not timed | not timed | 882.35 ± 1.5% | | 1.00 | 2.53 | 8.06 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13717.59 ± 16.0% | not timed | not timed | 14951.46 ± 0.5% | 6296.97 ± 7.2% | not timed | not timed | 13728.83 ± 3.3% | | 1.00 | 0.92 | 2.18 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12928.84 ± 2.9% | not timed | not timed | 14401.46 ± 0.7% | 5881.04 ± 5.5% | not timed | not timed | 12937.52 ± 4.1% | | 1.00 | 0.90 | 2.20 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13580.69 ± 0.8% | not timed | not timed | 14616.49 ± 4.2% | 6006.36 ± 3.4% | not timed | not timed | 13591.40 ± 0.7% | | 1.00 | 0.93 | 2.26 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 11802.37 ± 2.9% | not timed | not timed | 14621.65 ± 1.0% | 6216.46 ± 31.5% | not timed | not timed | 11828.65 ± 1.7% | | 1.00 | 0.81 | 1.90 |
| wild/url/search | 234965 | 114.94 ± 12.8% | not timed | not timed | 58.44 ± 1.4% | 2.10 ± 1.4% | not timed | not timed | 108.10 ± 12.6% | | 1.06 | 1.97 | 54.71 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 76.4% | not timed | not timed | 0.01 ± 3.6% | 0.01 ± 12.6% | not timed | not timed | 0.02 ± 70.3% | | 0.99 | 3.34 | 3.61 |
| dictionary/compile/english-15 | 1 | 0.29 ± 18.8% | not timed | not timed | 0.07 ± 12.5% | 0.10 ± 11.8% | not timed | not timed | 0.29 ± 1.5% | | 0.99 | 4.38 | 3.01 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.21 ± 15.5% | not timed | not timed | 0.02 ± 9.0% | 30.80 ± 12.7% | not timed | not timed | 0.21 ± 4.8% | | 0.98 | 11.21 | 0.0068 |
| reported/i1095-word-repetition/ascii-compile | 1 | 38.15 ± 17.6% | not timed | not timed | 12.09 ± 0.5% | 54.22 ± 16.2% | not timed | not timed | 38.57 ± 17.4% | | 0.99 | 3.16 | 0.70 |
| reported/i787-keywords/compile | 1 | 35.40 ± 3.5% | not timed | not timed | 1.76 ± 2.1% | 17.02 ± 38.9% | not timed | not timed | 35.33 ± 3.6% | | 1.00 | 20.08 | 2.08 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 352.56 ± 5.3% | not timed | not timed | 128.85 ± 2.8% | 542.18 ± 21.2% | not timed | not timed | 370.06 ± 14.1% | | 0.95 | 2.74 | 0.65 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 50.17 ± 13.4% | not timed | not timed | 3.75 ± 9.6% | 38.38 ± 12.7% | not timed | not timed | 50.89 ± 5.2% | | 0.99 | 13.37 | 1.31 |
| unicode/compile/one-letter | 53 | 6.08 ± 4.0% | not timed | not timed | 4.77 ± 2.8% | 53.01 ± 10.4% | not timed | not timed | 6.06 ± 8.2% | | 1.00 | 1.27 | 0.11 |
| unicode/compile/fifty-letters | 1 | 0.91 ± 5.5% | not timed | not timed | 0.11 ± 3.7% | 58.36 ± 18.4% | not timed | not timed | 0.91 ± 11.9% | | 1.00 | 8.62 | 0.0156 |
| unicode/compile/fifty-letters-ascii | 1 | 204.88 ± 11.5% | not timed | not timed | 54.07 ± 0.7% | 191.99 ± 31.5% | not timed | not timed | 209.39 ± 2.6% | | 0.98 | 3.79 | 1.07 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 406.66 ± 3.9% | not timed | not timed | 40.07 ± 1.5% | 641.73 ± 25.8% | not timed | not timed | 409.14 ± 4.5% | | 0.99 | 10.15 | 0.63 |
| unicode/compile/match-every-line-ascii | 4 | 673.03 ± 6.7% | not timed | not timed | 148.64 ± 1.1% | 651.46 ± 27.8% | not timed | not timed | 675.98 ± 1.6% | | 1.00 | 4.53 | 1.03 |
| unicode/compile/negated-class-matches-codepoint | 1 | 337.83 ± 6.9% | not timed | not timed | 43.10 ± 0.3% | 1138.66 ± 25.6% | not timed | not timed | 345.98 ± 11.0% | | 0.98 | 7.84 | 0.30 |
| wild/bibleref/compile | 3 | 4.98 ± 24.4% | not timed | not timed | 1.84 ± 1.0% | 28.13 ± 16.2% | not timed | not timed | 5.34 ± 6.1% | | 0.93 | 2.71 | 0.18 |
| wild/url/compile | 1 | 0.57 ± 26.4% | not timed | not timed | 0.14 ± 6.6% | 0.36 ± 66.8% | not timed | not timed | 0.62 ± 21.2% | | 0.91 | 3.99 | 1.58 |

